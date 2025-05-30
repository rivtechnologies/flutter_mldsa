
rm CHANGELOG.md
touch CHANGELOG.md
cat <<-EOF >> CHANGELOG.md
## 0.1.2

* Hotfix.

## 0.1.1

* Hotfix.
EOF


for tag in $(git tag); do
    echo "Checking tag: $tag"
    if echo "$tag" | grep -q 'dev'; then
      echo "Dev tag found, skipping"
    elif git cat-file -t "$tag" | grep -q '^tag$'; then
        echo "  → Annotated tag: $tag"
        annotation=$(git for-each-ref "refs/tags/$tag" --format='%(contents)')

        # insert the heading on line 1
        sed -i "1i## $tag" CHANGELOG.md
        # insert the annotation on line 2
        sed -i "2i* $annotation\n" CHANGELOG.md
    fi
done
