require 'formula'

class Bullet <Formula
  url 'http://bullet.googlecode.com/files/bullet-2.77.tgz'
  homepage 'http://bulletphysics.org/wordpress/'
  md5 '2f5074a1a29b618c672f1da4748e374b'

  depends_on 'cmake' => :build

  def options
    [
      ['--framework'  , "Build Frameworks"],
      ['--universal'  , "Build in universal mode"],
      ['--shared'     , "Build shared libraries"],
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

    args << "-DCMAKE_OSX_ARCHITECTURES='i386;x86_64'" if ARGV.include? "--universal"
    args << "-DBUILD_DEMOS=OFF" if not ARGV.include? "--build-demo"
    args << "-DBUILD_EXTRAS=OFF" if not ARGV.include? "--build-extra"

    system "cmake", *args
    system "make"
    system "make install"

    prefix.install 'Demos' if ARGV.include? "--build-demo"
    prefix.install 'Extras' if ARGV.include? "--build-extra"
  end
end
