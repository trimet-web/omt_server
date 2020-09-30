#
# To run:
# tmux new-session -d -s my_session 'run.sh >> out.txt 2>&1'
#
# -extra logging-
# grab continaer id via docker ps -a and then run docker logs <container_id>
#


# try to get into the gl dir
DIR=`dirname $0`
if [ $DIR == 'scripts' ]; then
  cd ./gl/
elif [ $DIR == '.' ]; then
  cd ../gl/
fi

if [[ $PWD != *'/gl' ]]; then
  echo "in $PWD ... not in the omt_server/gl directory..."
  exit
fi

# copy the soft-linked tiles.mbtiles generated by openmaptiles into a file here
# note: having or-wa.mbtiles be a soft link doesn't work
if [ ! -f ./data/or-wa.mbtiles ]; then
  cp ./data/tiles.mbtiles ./data/or-wa.mbtiles
fi

# public_url does not work as expected.  It appears to just allow you to have an alternate path to override static resources.
#  - https://github.com/maptiler/tileserver-gl/issues/477
# See options for some more details: https://tileserver.readthedocs.io/en/latest/usage.html#default-preview-style-and-configuration
# There may be useful things to do with the --mbtiles and --config flags
# This can be adapted to docker-compose, but we can work on that later.
docker run --rm -it -v $(pwd):/data -p 8080:80 -e "NODE_ENV=dev" maptiler/tileserver-gl --verbose

# start maputnik editor 
if [[ $1 == *'MAP'* || $1 == *'ED'* ]]; then
  echo "Starting Maputnik..."
  docker run --rm -u $(id -u):$(id -g) --name maputnik_editor -d -p 8088:8888 maputnik/editor
fi

