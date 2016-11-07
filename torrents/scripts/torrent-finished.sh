#!/bin/bash

exec > /var/log/transmission/finished-scripts.log

echo "Executing $0 due to finished torrent: $TR_TORRENT_NAME.."
echo "Envars:"
echo "TR_APP_VERSION:    $TR_APP_VERSION"
echo "TR_TIME_LOCALTIME: $TR_TIME_LOCALTIME"
echo "TR_TORRENT_DIR:    $TR_TORRENT_DIR"
echo "TR_TORRENT_HASH:   $TR_TORRENT_HASH"
echo "TR_TORRENT_ID:     $TR_TORRENT_ID"
echo "TR_TORRENT_NAME:   $TR_TORRENT_NAME"

echo "Done."
