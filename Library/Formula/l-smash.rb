require "formula"

class LSmash < Formula
  homepage "http://up-cat.net/L%252DSMASH.html"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.5.2", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

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
