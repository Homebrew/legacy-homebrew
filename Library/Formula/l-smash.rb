require "formula"

class LSmash < Formula
  homepage "http://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.11.8", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "1adaf173e775c8a8391f0aa86b022a983842889e" => :mavericks
    sha1 "891f49e1d5589fb705eb52e89e7656df259feb2c" => :mountain_lion
    sha1 "ca37cd43d1a0abcd702a3bb0316ba7ae2af8bd63" => :lion
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
