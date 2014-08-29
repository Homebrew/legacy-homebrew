require 'formula'

class Libantlr3c < Formula
  homepage 'http://www.antlr3.org'
  url 'http://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz'
  sha1 'faa9ab43ab4d3774f015471c3f011cc247df6a18'

  bottle do
    cellar :any
    sha1 "bd008a59f21dd058a78f328471f9c06dc9988a57" => :mavericks
    sha1 "3a1e53dd3d9253a0169b0bb7612ebc5c2f07671c" => :mountain_lion
    sha1 "661793739582bad4df7520dc15f8d51e09398d06" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
