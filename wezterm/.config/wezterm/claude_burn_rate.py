#!/usr/bin/env python3
import json
import os
import time
from datetime import datetime, timedelta

PROJECTS_DIR = os.path.expanduser('~/.claude/projects')

PRICE_INPUT        = 3.00   / 1_000_000
PRICE_OUTPUT       = 15.00  / 1_000_000
PRICE_CACHE_WRITE  = 3.75   / 1_000_000
PRICE_CACHE_READ   = 0.30   / 1_000_000

DAY_START_HOUR = 8  # "day" resets at 08:00 local time

def day_start_ts(now_epoch):
    now_local = datetime.fromtimestamp(now_epoch)
    boundary = now_local.replace(hour=DAY_START_HOUR, minute=0, second=0, microsecond=0)
    if now_local < boundary:
        boundary -= timedelta(days=1)
    return boundary.timestamp()

def empty_bucket():
    return {'input': 0, 'output': 0, 'cache_write': 0, 'cache_read': 0}

def add_usage(bucket, usage):
    bucket['input']       += usage.get('input_tokens', 0)
    bucket['output']      += usage.get('output_tokens', 0)
    bucket['cache_write'] += usage.get('cache_creation_input_tokens', 0)
    bucket['cache_read']  += usage.get('cache_read_input_tokens', 0)

def cost(bucket):
    return (
        bucket['input']       * PRICE_INPUT +
        bucket['output']      * PRICE_OUTPUT +
        bucket['cache_write'] * PRICE_CACHE_WRITE +
        bucket['cache_read']  * PRICE_CACHE_READ
    )

def main():
    now = time.time()
    cutoff_1h  = now - 3600
    cutoff_day = day_start_ts(now)
    # scan files touched since the earlier of the two cutoffs (minus buffer)
    cutoff_mtime = min(cutoff_1h, cutoff_day) - 300

    hour = empty_bucket()
    day  = empty_bucket()

    if not os.path.isdir(PROJECTS_DIR):
        print(json.dumps({'hour': {**hour, 'cost': 0.0}, 'day': {**day, 'cost': 0.0}}))
        return

    for project in os.scandir(PROJECTS_DIR):
        if not project.is_dir():
            continue
        try:
            entries = list(os.scandir(project.path))
        except PermissionError:
            continue
        for entry in entries:
            if not entry.name.endswith('.jsonl'):
                continue
            try:
                if entry.stat().st_mtime < cutoff_mtime:
                    continue
            except OSError:
                continue
            try:
                with open(entry.path, 'r', errors='replace') as f:
                    for line in f:
                        line = line.strip()
                        if not line:
                            continue
                        try:
                            obj = json.loads(line)
                        except json.JSONDecodeError:
                            continue
                        if obj.get('type') != 'assistant':
                            continue
                        ts_str = obj.get('timestamp', '')
                        if not ts_str:
                            continue
                        try:
                            ts = datetime.fromisoformat(
                                ts_str.replace('Z', '+00:00')
                            ).timestamp()
                        except ValueError:
                            continue
                        usage = obj.get('message', {}).get('usage', {})
                        if ts >= cutoff_1h:
                            add_usage(hour, usage)
                        if ts >= cutoff_day:
                            add_usage(day, usage)
            except OSError:
                continue

    print(json.dumps({
        'hour': {**hour, 'cost': cost(hour)},
        'day':  {**day,  'cost': cost(day)},
    }))

if __name__ == '__main__':
    main()
