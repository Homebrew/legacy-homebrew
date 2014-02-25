require 'formula'

class Xtail < Formula
  homepage 'http://www.unicom.com/sw/xtail'
  url 'http://www.unicom.com/files/xtail-2.1.tar.gz'
  sha1 '1188baaf47e19a1ed6176a17ee6d144078657c17'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    man1.mkpath
    bin.mkpath
    system "make install"
  end

  test do
    system "#{bin}/xtail"
  end
end
