require 'formula'

class Bullet < Formula
  url 'http://bullet.googlecode.com/files/bullet-2.79-rev2440.tgz'
  homepage 'http://bulletphysics.org/wordpress/'
  sha1 '49b4b362a0c8d279e32b946ef9578b1dd8c5987c'
  version '2.79'
  head 'http://bullet.googlecode.com/svn/trunk/', :using => :svn

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
