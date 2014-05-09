require "formula"

class LSmash < Formula
  homepage "http://up-cat.net/L%252DSMASH.html"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.9.1", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "96d2cd29988f4075cdd67ce335c43d747a083623" => :mavericks
    sha1 "0fc1e1784564995eb5dd06c41173fc43d5d4ca83" => :mountain_lion
    sha1 "1dfa0062b9a34c86d377f426878d1ff8c336725a" => :lion
  end

  def install
    args = ["--prefix=#{prefix}", "--enable-shared"]

    # For getting version information correctly in the configure
    buildpath.install_symlink cached_download/".git"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/boxdumper", "-v"
    system "#{bin}/muxer", "-v"
    system "#{bin}/remuxer", "-v"
    system "#{bin}/timelineeditor", "-v"
  end
end
