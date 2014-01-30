require 'formula'

class Mikmod < Formula
  homepage 'http://mikmod.raphnet.net/'
  url 'http://sourceforge.net/projects/mikmod/files/mikmod/3.2.5/mikmod-3.2.5.tar.gz'
  sha1 '2c4d2abac01af37c45db2b92b74636dce36eba31'

  depends_on 'libmikmod'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def test
    system "#{bin}/mikmod", "-V"
  end
end
