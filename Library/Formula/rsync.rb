require 'formula'

class Rsync < Formula
  url 'http://www.samba.org/ftp/rsync/rsync-3.0.9.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 '5ee72266fe2c1822333c407e1761b92b'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "rsync --version"
  end
end
