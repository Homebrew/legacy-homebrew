require 'formula'

class Autoconf < Formula
  url 'http://mirror.anl.gov/pub/gnu/autoconf/autoconf-2.68.tar.gz'
  homepage 'http://www.gnu.org/software/autoconf/'
  md5 'c3b5247592ce694f7097873aa07d66fe'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
