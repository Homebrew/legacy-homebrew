require 'formula'

class Mikmod < Formula
  homepage 'http://mikmod.raphnet.net/'
  url 'http://mikmod.shlomifish.org/files/mikmod-3.2.2.tar.gz'
  sha1 '37640492c0ba3aebc277a251e1d012119e2edee8'

  depends_on 'libmikmod'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
