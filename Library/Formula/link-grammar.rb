require 'formula'

class LinkGrammar < Formula
  homepage 'http://www.abisource.com/projects/link-grammar/'
  url 'http://www.abisource.com/downloads/link-grammar/4.7.9/link-grammar-4.7.9.tar.gz'
  sha1 'd58e565b1728a78a63678ab2fe59eb5f20360a2f'

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
