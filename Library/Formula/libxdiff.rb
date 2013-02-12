require 'formula'

class Libxdiff < Formula
  homepage 'http://www.xmailserver.org/xdiff-lib.html'
  url 'http://www.xmailserver.org/libxdiff-0.23.tar.gz'
  sha1 'f92eff48eeb49d5145ddafcb72dcfb18f5d07303'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
