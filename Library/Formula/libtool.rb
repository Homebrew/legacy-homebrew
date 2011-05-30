require 'formula'

class Libtool < Formula
  url 'http://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz'
  homepage 'http://www.gnu.org/software/libtool'
  md5 'b32b04148ecdd7344abc6fe8bd1bb021'

  # depends_on 'cmake'
  depends_on 'autoconf'

  def install
    # macports uses also:
    # configure.env-append GREP=/usr/bin/grep \
    # SED=/usr/bin/sed
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end
