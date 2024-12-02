#!/bin/bash

# 変数の設定
ZIP_FILE="./wlt_replace_package_cache.zip"  # Zipファイルのパス
TARGET_BASE_DIR="./Library/PackageCache"  # コピー先の基準ディレクトリ
TARGET_PREFIX="com.microsoft.mixedreality.worldlockingtools"  # 一致すべきプレフィックス

# 一時解凍ディレクトリ
TEMP_DIR="temp_extracted"
mkdir -p "$TEMP_DIR"

# Zipファイルを解凍
unzip -q "$ZIP_FILE" -d "$TEMP_DIR"

# 一致するディレクトリを探す
TARGET_DIR=$(find "$TARGET_BASE_DIR" -type d -name "${TARGET_PREFIX}*" | head -n 1)

if [ -z "$TARGET_DIR" ]; then
    echo "対象ディレクトリが見つかりませんでした: ${TARGET_PREFIX}"
    echo "一度UnityEditorでプロジェクトを開いてから再度実行してください"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "ターゲットディレクトリ: $TARGET_DIR"

# 解凍した中身のフォルダ構造を取得
EXTRACTED_SUBDIR=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ -z "$EXTRACTED_SUBDIR" ]; then
    echo "Zipファイル内に有効なフォルダが見つかりません。"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo "解凍されたフォルダ: $EXTRACTED_SUBDIR"

# ターゲットディレクトリにコピーして置き換え
cp -r "$EXTRACTED_SUBDIR"/* "$TARGET_DIR"

# 一時ディレクトリを削除
rm -rf "$TEMP_DIR"

echo "ファイルがコピーされました。"
