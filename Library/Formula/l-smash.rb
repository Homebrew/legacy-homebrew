require "formula"

class LSmash < Formula
  homepage "http://up-cat.net/L%252DSMASH.html"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.5.2", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "7e0fda0145b2eceaa950e9cccf84205c9dcaab47" => :mavericks
    sha1 "0e9a018a8d3f818c42e98153e003018b3ccb6982" => :mountain_lion
    sha1 "088add54110cd25086fced2086593a8ec46dafb2" => :lion
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
