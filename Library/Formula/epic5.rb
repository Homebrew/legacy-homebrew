require 'formula'

class Epic5 < Formula
  homepage 'http://www.epicsol.org/'
  url 'http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-1.1.6.tar.gz'
  sha1 '5b7605a28d184338357abd655e157eed5ad699d7'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/epic5", "-v"
  end
end
