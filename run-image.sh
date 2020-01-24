docker run \
  --rm \
  -it \
  -p 1313:1313 \
  -v $PWD:/ \
  phiroict/hugo-builder:scratch_20200124.0 \
  /hugo server \
  --bind 0.0.0.0 

  