require 'formula'

class LinkGrammar < Formula
  homepage 'http://www.abisource.com/projects/link-grammar/'
  url 'http://www.abisource.com/downloads/link-grammar/4.7.14/link-grammar-4.7.14.tar.gz'
  sha1 'dd8d03021e6c68933093cd61317a4d4d0bae6f57'

  bottle do
    sha1 "61a73dabd6a7c531c1f895ff912b6c2814d8ab87" => :mavericks
    sha1 "ca9f010bcaa5ca323249e8978c600ab53a8e8386" => :mountain_lion
    sha1 "418fcfe1f703a827089454957664a981103c73e9" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on :ant => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
