require 'formula'

class Dialog <Formula
  url 'ftp://invisible-island.net/dialog/dialog.tar.gz'
  homepage 'http://invisible-island.net/dialog/'
  md5 '519c0a0cbac28ddb992111ec2c3f82aa'
  version '1.1.20070704'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
