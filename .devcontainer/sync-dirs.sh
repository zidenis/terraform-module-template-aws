#!/bin/bash

SRC_A="/tmp/src"
SRC_B="/home/vscode/workspace"

LOCK="/home/vscode/sync-dirs.lock"
DELAY=1

sync_a_to_b() {
  if [ -f "${LOCK}" ]; then return; fi
  touch "${LOCK}"
  echo "$(date) : ${SRC_A} -> ${SRC_B}"
  rsync -a --delete --exclude ".git" --exclude ".terraform" "${SRC_A}/" "${SRC_B}/"
  sleep ${DELAY}
  rm -f "${LOCK}"
}

sync_b_to_a() {
  if [ -f "${LOCK}" ]; then return; fi
  touch "${LOCK}"
  echo "$(date) : ${SRC_B} -> ${SRC_A}"
  rsync -a --delete --exclude ".git" --exclude ".terraform" "${SRC_B}/" "${SRC_A}/"
  sleep ${DELAY}
  rm -f "${LOCK}"
}

# Sync inicial
sync_a_to_b

echo "$(date) : watching ${SRC_A} -> ${SRC_B}"
inotifywait -mr -e modify,create,delete,move --exclude '(^|/)\.git/' --exclude '(^|/)\.terraform/' "${SRC_A}" |
while read -r path action file; do
  echo "$(date) : ${path} : ${action} : ${file}"
  sync_a_to_b
done &

echo "$(date) : watching ${SRC_B} -> ${SRC_A}"
inotifywait -mr -e modify,create,delete,move --exclude '(^|/)\.git/' --exclude '(^|/)\.terraform/' "${SRC_B}" |
while read -r path action file; do
  echo "$(date) : ${path} : ${action} : ${file}"
  sync_b_to_a
done &

wait