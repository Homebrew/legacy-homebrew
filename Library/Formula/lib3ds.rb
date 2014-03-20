require 'formula'

class Lib3ds < Formula
  homepage 'http://code.google.com/p/lib3ds/'
  url 'https://lib3ds.googlecode.com/files/lib3ds-1.3.0.zip'
  sha1 '544262eac73c1e4a1d77f0f1cbd90b990a996db8'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
