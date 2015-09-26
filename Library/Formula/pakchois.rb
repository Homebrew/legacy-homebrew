require "formula"

class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "http://www.manyfish.co.uk/pakchois/"
  url "http://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha1 "dea8a9a50ec06595b498bdefd1daacdb86e9ceda"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
