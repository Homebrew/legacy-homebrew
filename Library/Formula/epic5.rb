require 'formula'

class Epic5 < Formula
  homepage 'http://www.epicsol.org/'
  url 'http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/epic5-1.1.5.tar.gz'
  sha1 '7a65bed6971118b0f0931652d6eee5090c75d449'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" 
  end

  def test
    system "epic5"
  end
end
