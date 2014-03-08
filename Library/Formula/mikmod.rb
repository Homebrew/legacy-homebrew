require 'formula'

class Mikmod < Formula
  homepage 'http://mikmod.raphnet.net/'
  url 'https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.5/mikmod-3.2.5.tar.gz'
  sha1 '2c4d2abac01af37c45db2b92b74636dce36eba31'

  depends_on 'libmikmod'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/mikmod", "-V"
  end
end
