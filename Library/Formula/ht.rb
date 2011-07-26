require 'formula'

class Ht < Formula
  url 'http://sourceforge.net/projects/hte/files/ht-source/ht-2.0.18.tar.bz2'
  homepage 'http://hte.sourceforge.net/'
  md5 '9cd5c52bb3fbae5c631875cd0de3318c'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--disable-x11-textmode",
                          "--prefix=#{prefix}"
    system "chmod", "+x", "install-sh"
    system "make install"
  end
end
