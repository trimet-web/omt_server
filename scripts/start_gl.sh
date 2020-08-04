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

docker run --rm -it -v $(pwd):/data -p 8080:80 maptiler/tileserver-gl
