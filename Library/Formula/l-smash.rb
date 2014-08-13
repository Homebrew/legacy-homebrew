require "formula"

class LSmash < Formula
  homepage "http://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.13.0", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "fb4bc0f2bb01c37837128efc55211515de9f3bf8" => :mavericks
    sha1 "9915a7a26cd1ead39449ce4aa7cfbb4d696a5760" => :mountain_lion
    sha1 "bf5345f8ebecdbcdab9c260c2c3f0de024232474" => :lion
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
