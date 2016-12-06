require 'formula'

class Duti < Formula
  homepage 'http://duti.sourceforge.net'
  url 'http://www.macupdate.com/download/26737/duti-1.5.1.tar.gz'
  sha1 'ac199f936180a3ac62100ae9a31e107a45330557'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "duti -V"
  end
end
