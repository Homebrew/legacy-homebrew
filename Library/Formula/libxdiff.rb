require 'formula'

class Libxdiff <Formula
  url 'http://www.xmailserver.org/libxdiff-0.23.tar.gz'
  homepage 'http://www.xmailserver.org/xdiff-lib.html'
  md5 '8970281543130411d8a1b1f004a8418b'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
