latest_tag=$(git tag --sort=taggerdate | tail -n1)

version=${latest_tag#\v}

yq eval ".version = \"$version\"" -i pubspec.yaml