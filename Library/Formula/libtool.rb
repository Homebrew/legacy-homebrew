# Libtool 2.4
# rhubarb@ruction.org

require 'formula'

class Libtool < Formula
  url 'http://ftp.gnu.org/gnu/libtool/libtool-2.4.tar.gz'
  homepage 'http://www.gnu.org/software/libtool'
  md5 'b32b04148ecdd7344abc6fe8bd1bb021'

  def install
    system "./configure",  "--prefix=#{prefix}"
    system "make install"
  end
end
