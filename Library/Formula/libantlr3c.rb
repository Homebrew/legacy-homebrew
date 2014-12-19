require 'formula'

class Libantlr3c < Formula
  homepage 'http://www.antlr3.org'
  url 'http://www.antlr3.org/download/C/libantlr3c-3.4.tar.gz'
  sha1 'faa9ab43ab4d3774f015471c3f011cc247df6a18'

  bottle do
    cellar :any
    revision 1
    sha1 "5340de248798194c46c5112c73a1ba409912059d" => :yosemite
    sha1 "044b66cb95b396080f1729cc04f9a960f08e6ea5" => :mavericks
    sha1 "b02f52cf3c696b52974e90532cf66964e61c750d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
