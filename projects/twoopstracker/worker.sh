#!/bin/bash
# --- begin runfiles.bash initialization v2 ---
# Copy-pasted from the Bazel Bash runfiles library v2.
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
source "$0.runfiles/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
{ echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---
manage=$(rlocation "cfalib/projects/twoopstracker/twoopstracker")

if [[ ! -f "${manage:-}" ]]; then
  echo >&2 "ERROR: could not look up the manage tool path"
  exit 1
fi

python3 $manage migrate --noinput    # no input needed
python3 $manage collectstatic --noinput    # no input needed

# # Prepare log files and start outputting logs to stdout
# touch /app/logs/gunicorn.log
# touch /app/logs/access.log
# touch /app/logs/celery.log

# tail -n 0 -f /app/logs/*.log &

# # Start celery worker
# celery -A twoopstracker worker -l INFO &> /app/logs/celery.log &

# # everytime the container is restarted, the scheduler will reset
# rm -rf celerybeat-schedule
# # Start celery beat service
# celery -A twoopstracker beat -l INFO &> /app/logs/celery.log &

# # Start Gunicorn processes
# echo Starting Gunicorn.
# exec gunicorn \
#     --bind 0.0.0.0:8000 \
#     --workers=${TWOOPS_TRACKER_GUNICORN_WORKERS:-3} \
#     --worker-class gevent \
#     --log-level=${TWOOPS_GUNICORN_LOG_LEVEL:-warning} \
#     --timeout=${TWOOPS_GUNICORN_TIMEOUT:-60} \
#     --log-file=/app/logs/gunicorn.log \
#     --access-logfile=/app/logs/access.log \
#     --name twoopsTracker \
#     ${TWOOPSTRACKER_GUNICORN_EXTRA_CONFIG:-} \
#     twoopstracker.wsgi:application
