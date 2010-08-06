require 'formula'

class ArgpStandalone <Formula
  url 'http://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz'
  homepage 'http://www.lysator.liu.se/~nisse/misc/'
  md5 '720704bac078d067111b32444e24ba69'

# depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
#   system "cmake . #{std_cmake_parameters}"
#    system "make install"
    include.install('argp.h')
    lib.install('libargp.a')
  end
end
