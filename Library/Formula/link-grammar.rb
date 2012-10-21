require 'formula'

class LinkGrammar < Formula
  url 'http://www.abisource.com/downloads/link-grammar/4.7.4/link-grammar-4.7.4.tar.gz'
  homepage 'http://www.abisource.com/projects/link-grammar/'
  sha1 '75a3963c89950c00bb1a8a2fc557cb33ae398d11'

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
