# package.sh
# script to package files into a .love
#
# To use the --run option, make sure you have exported the PATH to the love executable
# e.g. nano ~/.bash_profile and export PATH=/Applications/love.app/Contents/MacOS:$PATH

# parsing args
RUN=0
SEND=""

for i in "$@"
do
case $i in
    # Run the game after the build
    -r*|--run*)
        RUN=1
        shift
    ;;
    *)
    # unknown option
    ;;
esac
done


echo 'deleting Mac OS .DS_Store files..'
find .. -name .DS_Store -delete

echo 'creating temp folder..'
mkdir -p temp

echo 'copying source files..'
cp -r ../src/* temp/

echo 'copying resources..'
rsync -r --exclude=*.tmx ../res temp/

echo 'packaging everything into .love file..'
cd temp
zip -9 -q -r familygame.love .

echo 'moving build into bin folder..'
mkdir -p ../../bin
mv familygame.love ../../bin/
cd ../

echo 'removing temp folder..'
rm -rf temp

if [ $RUN -eq 1 ]; then
    echo 'launching the game..'
    love ../bin/familygame.love $*
fi
