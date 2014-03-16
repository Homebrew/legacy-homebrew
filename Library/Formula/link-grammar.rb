require 'formula'

class LinkGrammar < Formula
  homepage 'http://www.abisource.com/projects/link-grammar/'
  url 'http://www.abisource.com/downloads/link-grammar/4.8.6/link-grammar-4.8.6.tar.gz'
  sha1 '2230d40aa37dc06e3987123ac659d2f7148f4591'

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
