## Running the Docker Container

In the Hugo website directory.

```
docker run --rm -it -v $PWD:/src catosplace/hugo-builder hugo 
```

### Server

```
docker run --rm -it -v $PWD:/src catosplace/hugo-builder hugo server --bind 0.0.0.0
```

#### Aliases   

## Linting the Dockerfile

```
docker run --rm -i hadolint/hadolint < Dockerfile
```

```
docker run -it --rm --privileged \
  -v $PWD:/root/ \
  projectatomic/dockerfile-lint \
  dockerfile_lint -r lint_rules/dockerfile_lint_rules.yml
```

## Building the Docker Image

```
docker build \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  -t catosplace/hugo-builder-new .
```

## Debugging

```
docker exec --it $CONTAINER /bin/sh
```

## Check Healtcheck

```
docker inspect --format='{{json .State.Health}}' $CONTAINER
```
