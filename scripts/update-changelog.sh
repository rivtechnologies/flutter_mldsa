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

    # insert the heading on line 1
    sed -i "1i## $tag" CHANGELOG.md
    # insert a blank line after the heading
    sed -i $'2i\n' CHANGELOG.md
    # insert the annotation on line 2
    sed -i $"3i* $annotation\n" CHANGELOG.md
fi
