require "formula"

class LSmash < Formula
  homepage "http://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.12.3", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "1a29a960c129a54ac162a5ae9e4f04820e8b1bbc" => :mavericks
    sha1 "28834b347adcc631cf04de3560c7fb7e09d269b5" => :mountain_lion
    sha1 "7fbf5a5abc69a1aaa9d1037a3ec7f333b64d19cc" => :lion
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
