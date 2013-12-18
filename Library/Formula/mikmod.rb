require 'formula'

class Mikmod < Formula
  homepage 'http://mikmod.raphnet.net/'
  url 'http://sourceforge.net/projects/mikmod/files/mikmod/3.2.4/mikmod-3.2.4.tar.gz'
  sha1 '7d37c60d96c83ea38b36845a5fb7e5c757b42233'

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
