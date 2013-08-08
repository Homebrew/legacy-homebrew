require 'formula'

class Nickle < Formula
  homepage 'http://www.nickle.org/'
  url 'http://www.nickle.org/release/nickle-2.77.tar.gz'
  sha1 'b391e9fdc4e1bf48edeb10e587f472f04f571f29'

  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
