require 'formula'

class LinkGrammar < Formula
  homepage 'http://www.abisource.com/projects/link-grammar/'
  url 'http://www.abisource.com/downloads/link-grammar/4.7.11/link-grammar-4.7.11.tar.gz'
  sha1 'a4a6316d8f800b80cddf0cb2b2218e0d69d9c8ce'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/link-parser", "--version"
  end
end
