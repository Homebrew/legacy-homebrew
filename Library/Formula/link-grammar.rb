class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/4.7.14/link-grammar-4.7.14.tar.gz"
  sha256 "6fe8b46c6f134c5c1e43fc0eaae048fe746c533a0cae8d63ad07fc2a3dff7667"

  bottle do
    sha1 "61a73dabd6a7c531c1f895ff912b6c2814d8ab87" => :mavericks
    sha1 "ca9f010bcaa5ca323249e8978c600ab53a8e8386" => :mountain_lion
    sha1 "418fcfe1f703a827089454957664a981103c73e9" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on :ant => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
