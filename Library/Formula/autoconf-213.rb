require 'formula'

class Autoconf < Formula
  url 'http://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz'
  homepage 'http://www.gnu.org/software/autoconf/'
  md5 '9de56d4a161a723228220b0f425dc711'

  def install
    system "./configure", "--program-suffix=213",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make install"
  end
end
