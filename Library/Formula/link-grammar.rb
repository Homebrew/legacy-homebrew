require 'formula'

class LinkGrammar < Formula
  url 'http://www.abisource.com/downloads/link-grammar/4.7.4/link-grammar-4.7.4.tar.gz'
  homepage 'http://www.abisource.com/projects/link-grammar/'
  md5 'e90e702a953641713a1292db20677bd2'

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
