require 'formula'

class Bullet < Formula
  homepage 'http://bulletphysics.org/wordpress/'
  url 'http://bullet.googlecode.com/files/bullet-2.80-rev2531.tgz'
  version '2.80'
  sha1 '65a7dbb852cc3b92f40d79a2a368233442747228'
  head 'http://bullet.googlecode.com/svn/trunk/'

  depends_on 'cmake' => :build

  def options
    [
      ['--framework'  , "Build Frameworks"],
      ['--universal'  , "Build in universal mode"],
      ['--shared'     , "Build shared libraries"],
      ['--build-demo' , "Build demo applications"],
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

    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if ARGV.build_universal?
    args << "-DBUILD_DEMOS=OFF" if not ARGV.include? "--build-demo"
    args << "-DBUILD_EXTRAS=OFF" if not ARGV.include? "--build-extra"

    system "cmake", *args
    system "make"
    system "make install"

    prefix.install 'Demos' if ARGV.include? "--build-demo"
    prefix.install 'Extras' if ARGV.include? "--build-extra"
  end
end
