require 'formula'

class Autoconf < Formula
  url 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.68.tar.gz'
  homepage 'http://www.gnu.org/software/autoconf'
  md5 'c3b5247592ce694f7097873aa07d66fe'

  # depends_on 'cmake'
  depends_on 'm4'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    # if libtool is later installed then we need also to do:
    #   reinplace "s|'libtoolize'|'glibtoolize'|" ${worksrcpath}/bin/autoreconf.in
    inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
    system "make install"
  end
end
