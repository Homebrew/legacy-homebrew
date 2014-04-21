require 'formula'

class LinkGrammar < Formula
  homepage 'http://www.abisource.com/projects/link-grammar/'
  url 'http://www.abisource.com/downloads/link-grammar/4.7.14/link-grammar-4.7.14.tar.gz'
  sha1 'dd8d03021e6c68933093cd61317a4d4d0bae6f57'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
