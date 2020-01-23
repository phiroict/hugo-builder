## Choices 

The Git version is explicitly defined in the dockerfile as that enables us to releases patches with security fixes. Now the git version is closely linked with the alpine version so you need to check on any alpine release if the git version still installs and or of there are patched versions available fixing security issues. 


## Running the Docker Container


In the Hugo website directory.
First make sure the git submodules have been downloaded. 
In the website root: 
```
git submodule init
git submodule update
```
Or you will miss the layouts. 

Also in the root website directory create the layouts directory
```
mkdir layouts
```
As the hugo app expects it to be there. 
Now you can run the build or run the server directly as that also runs the build:

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

Prior to building at this time need to set Environment variables:

```
export ALPINE_VERSION=3.11.2
```

```
docker build \
  --build-arg ALPINE_VERSION \
  --build-arg CREATE_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
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
