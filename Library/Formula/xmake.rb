class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "0fb8b71ed1af4db2ad154a7a50386bf66de54f548a171c9d730c115641f4466f"
  head "https://github.com/waruqi/xmake.git"
  
  def install_for_brew; <<-EOS.undent
    #!/bin/bash

    # is debug?
    debug=n
    verbose=

    #debug=y
    #verbose=-v

    # prefix
    prefix=/usr/local
    if [ $1 ] && [ -d $1 ]; then
        prefix=$1
    fi
    echo installing to $prefix ...

    # probe plat
    uname=`uname`
    if [ $uname = "MSVC" ]; then
        plat=msvc
    elif [ $uname = "Darwin" ] || [ `uname | egrep -i darwin` ]; then
        plat=mac
    elif [ $uname = "Linux" ] || [ `uname | egrep -i linux` ]; then
        plat=linux
    elif [ `uname | egrep -i msys` ]; then
        plat=msvc
    elif [ `uname | egrep -i cygwin` ]; then
        plat=msvc
    else
        plat=linux
    fi
    echo plat: $plat

    # probe arch
    arch=x86
    if [ $plat = "linux" ] || [ $plat = "mac" ]; then
        if [ `getconf LONG_BIT` = "64" ]; then
            arch=x64
        fi
    fi
    echo arch: $arch

    # compile xmake-core
    echo compiling xmake-core ...
    cd ./core
    if [ -f .config.mak ]; then 
        rm .config.mak
    fi
    make f DEBUG=$debug > ../install.log
    if [ $? -ne 0 ]; then 
        cat ../install.log
        exit; 
    fi
    make c >> ../install.log
    make >> ../install.log
    if [ $? -ne 0 ]; then 
        make o
        cat ../install.log
        exit; 
    fi
    make i
    cd ..

    # create the xmake install directory
    xmake_dir_install=$prefix/share/xmake
    if [ -d $xmake_dir_install ]; then
        sudo rm -rf $xmake_dir_install
    fi
    if [ ! -d $prefix/bin ]; then
        sudo mkdir $prefix/bin
    fi
    if [ ! -d $prefix/share ]; then
        sudo mkdir $prefix/share
    fi
    if [ ! -d $xmake_dir_install ]; then
        sudo mkdir $xmake_dir_install
    fi
    if [ $? -ne 0 ]; then 
        echo "create $xmake_dir_install failed!"
        exit; 
    fi

    # install the xmake core file
    xmake_core=./core/bin/demo.pkg/bin/$plat/$arch/demo.b
    xmake_core_install=$xmake_dir_install/xmake
    sudo cp $xmake_core $xmake_core_install
    sudo chmod 777 $xmake_core_install
    if [ $? -ne 0 ]; then
        echo "install xmake core failed!"
        exit;
    fi

    # install the xmake directory
    sudo cp -r ./xmake/* $xmake_dir_install/
    if [ $? -ne 0 ]; then
        echo "install xmake directory failed!"
        exit;
    fi

    # make the xmake loader
    xmake_loader=/tmp/xmake_loader
    echo "#!/bin/bash" > $xmake_loader
    echo "export XMAKE_PROGRAM_DIR=$xmake_dir_install" >> $xmake_loader
    echo "$xmake_core_install $verbose \"\$@\"" >> $xmake_loader
    if [ $? -ne 0 ]; then 
        echo "make xmake loader failed!"
        exit;
    fi

    # install the xmake loader
    xmake_loader_install=$prefix/bin/xmake
    sudo mv $xmake_loader $xmake_loader_install
    sudo chmod 777 $xmake_loader_install
    if [ $? -ne 0 ]; then 
        echo "install xmake loader failed!"
        exit;
    fi

    # ok
    echo ok!
    EOS
  end

  def install
    (prefix+"install_for_brew").write install_for_brew
    system "mv", prefix+"install_for_brew", "./install_for_brew"
    system "chmod", "777", "./install_for_brew"
    system "./install_for_brew", prefix
  end

  test do
    (testpath/"xmake.lua").write("")
    system "#{bin}/xmake"
  end
end
