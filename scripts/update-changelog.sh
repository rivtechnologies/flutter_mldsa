#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

tag="$1"

echo "Checking tag: $tag"
if echo "$tag" | grep -q 'dev'; then
  echo "Dev tag found, skipping"
elif git cat-file -t "$tag" | grep -q '^tag$'; then
    echo "  → Annotated tag: $tag"
    annotation=$(git for-each-ref "refs/tags/$tag" --format='%(contents)')

    printf "## $tag\n\n* $annotation\n\n" | cat - CHANGELOG.md > temp && mv temp CHANGELOG.md
fi
