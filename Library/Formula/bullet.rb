require 'formula'

class Bullet <Formula
  url 'http://bullet.googlecode.com/files/bullet-2.77.tgz'
  version "2.77"
  homepage 'http://bulletphysics.org/wordpress/'
  md5 '2f5074a1a29b618c672f1da4748e374b'

  #depends_on 'cmake' => :build

  def options
    [
      ['--framework'  , "Build Frameworks"],
      ['--universal'  , "Build by universal (32-bit and 64-bit) mode"],
      ['--shared'     , "Build Shared libs"],
      ['--build-demo' , "Build demo application"],
      ['--build-extra', "Build extra library"]
    ]
  end

  def install
    args = []

    if ARGV.include? "--framework"
      args << "-DBUILD_SHARED_LIBS=ON" << "-DFRAMEWORK=ON"
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}/Frameworks"
      args << "-DCMAKE_INSTALL_NAME_DIR=#{prefix}/Frameworks"
    else
      args << "-DBUILD_SHARED_LIBS=ON" if ARGV.include? "--shared"
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    end

    if ARGV.include? "--universal"
      args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'"
    end
    
    if ARGV.include? "--build-demo"
        args << "-DBUILD_DEMOS=ON"
    else
        args << "-DBUILD_DEMOS=OFF"
    end
    
    if ARGV.include? "--build-extra"
        args << "-DBUILD_EXTRAS=ON"
    else
        args << "-DBUILD_EXTRAS=OFF"
    end

    puts "-- using cmake flags --"
    puts *args
    puts "----"

    system "cmake", *args
    system "make"
    system "make install"

    prefix.install ['Demos'] if ARGV.include? "--build-demo"
    prefix.install ['Extras'] if ARGV.include? "--build-extra"
  end

  def caveats
    framework_caveats = <<-EOS.undent
      # ---- Framework builded. please symlink to standard OS X location
      # You can use here as bullet_symlink.sh
      #!/bin/sh

      #Bullet Librarys installed to:
      #  #{prefix}/Frameworks/Bullet

      #You may want to symlink(or copy) Frameworks to a standard OS X location,
      #such as:
        sudo ln -s #{prefix}/Frameworks/BulletDynamics.framework /Library/Frameworks/BulletDynamics.framework
        sudo ln -s #{prefix}/Frameworks/BulletCollision.framework /Library/Frameworks/BulletCollision.framework
        sudo ln -s #{prefix}/Frameworks/LinearMath.framework /Library/Frameworks/LinearMath.framework
        sudo ln -s #{prefix}/Frameworks/BulletSoftBody.framework /Library/Frameworks/BulletSoftBody.framework
        sudo ln -s #{prefix}/Frameworks/BulletSoftBodySolvers_CPU.framework /Library/Frameworks/BulletSoftBodySolvers_CPU.framework
        sudo ln -s #{prefix}/Frameworks/BulletSoftBodySolvers_OpenCL_Apple.framework /Library/Frameworks/BulletSoftBodySolvers_OpenCL_Apple.framework
        sudo ln -s #{prefix}/Frameworks/BulletSoftBodySolvers_OpenCL_Mini.framework /Library/Frameworks/BulletSoftBodySolvers_OpenCL_Mini.framework
      #or add [#{prefix}/Frameworks] to Framework search path when compile programs ex.) gcc -F#{prefix}/Frameworks

      #and symlink librarys
      #such as:
        ln -s #{prefix}/Frameworks/libBulletMultiThreaded.2.77.dylib /usr/local/lib/libBulletMultiThreaded.dylib
        ln -s #{prefix}/Frameworks/libMiniCL.2.77.dylib /usr/local/lib/libMiniCL.dylib
      #or add [#{prefix}/Frameworks] to library search path when compile programs ex.) gcc -I#{prefix}/Frameworks
      # ------------------------------------
    EOS

    message=""
    message+"Demo Application is compiled in [#{prefix}/Demos]" if ARGV.include? "--build-demo"
    message+"Extra Library is compiled in [#{prefix}/Extras]" if ARGV.include? "--build-extra"

    message = framework_caveats if ARGV.include? "--framework"
    return message
  end
end
