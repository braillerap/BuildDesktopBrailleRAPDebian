Xvfb :99 -screen 0 1024x768x16 &
DISPLAY=:99.0
export DISPLAY

python3 -m venv venv
source ./venv/bin/activate

git pull
git checkout $BRANCH_BUILD 

git-changelog -x -s v0.6.0 -f `git tag | tail -n 1`

printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34minstall python dependencies\e[0m\n" 
printf "\e[1;34m######################\e[0m\n"
pip install -r /home/builduser/DesktopBrailleRAP/requirement_linux.txt

printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mplatform status\e[0m\n" 
printf "\e[1;34m######################\e[0m\n"
printf "python :%s %s\n" $(python --version)
printf "nodejs :%s\n" $(node --version)
printf "npm    :%s\n" $(npm --version)
printf "branch :%s\n" "$BRANCH_BUILD"


npm install

rm -r /home/builduser/dist/*

printf "writing python linux dependencies\n" 
pip freeze > /home/builduser/dist/requirement_test.txt




# !! delete .gitignore !!
#ls -lah /home/builduser/DesktopBrailleRAP/package/debian/desktopbraillerap-debian/bin/.*
#rm /home/builduser/DesktopBrailleRAP/package/debian/desktopbraillerap-debian/bin/.*

tree  -a /home/builduser/DesktopBrailleRAP/package/debian

#printf "\e[1;34mBuild debug \e[0m\n"
#npm run builddev
printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mBuild production ready\e[0m\n"
printf "\e[1;34m######################\e[0m\n"
npm run builddebian

printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mBuild finished\n"
printf "\e[1;34m######################\e[0m\n"


printf "\e[1;34m######################\e[0m\n"
printf "\e[1;34mSome useful info\e[0m\n"
printf "\e[1;34m######################\e[0m\n"
ldd --version
ldd /home/builduser/DesktopBrailleRAP/dist/desktopbraillerap-debian
dpkg -S 'libc.so.6'
dpkg -S 'libdl.so.2'
dpkg -S 'libpthread.so.0'
dpkg -S 'libz.so.1'


 if [ $(find /home/builduser/DesktopBrailleRAP/dist/ -name "desktopbraillerap-debian-*.deb") ];
  then
    
    for f in /home/builduser/DesktopBrailleRAP/dist/desktopbraillerap-debian-*.deb
    do
        md5sum $f > $f.md5sum
        sed -i -r "s/ .*\/(.+)/  \1/g" $f.md5sum
    done
    cp -r /home/builduser/DesktopBrailleRAP/dist/* /home/builduser/dist/
    ls -lah /home/builduser/dist/*
    printf "\e[0mCompilation: \e[1;32mSucceeded\n"
    printf "\n"
    printf "####### #    # \n"
    printf "#     # #   #  \n"
    printf "#     # #  #   \n"
    printf "#     # ###    \n"
    printf "#     # #  #   \n"
    printf "#     # #   #  \n"
    printf "####### #    # \n"
    printf "\n" 
  else
    printf "\e[0mCompilation: \e[0;31mFailed\n"
    printf "\n"
    printf "#    # #######\n"
    printf "#   #  #     #\n"
    printf "#  #   #     #\n"
    printf "# ###  #     #\n"
    printf "#  #   #     #\n"
    printf "#   #  #     #\n"
    printf "#    # #######\n"
    printf "\n" 
  fi
