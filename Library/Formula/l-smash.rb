class LSmash < Formula
  desc "Tool for working with MP4 files"
  homepage "http://l-smash.github.io/l-smash/"
  url "https://github.com/l-smash/l-smash.git", :tag => "v1.13.2", :shallow => false
  head "https://github.com/l-smash/l-smash.git"

  bottle do
    cellar :any
    sha1 "468918e2a5008899f0630ce2a5cfc39e7cef7f77" => :mavericks
    sha1 "174bb9962f8d81a3d2f5914eeca9dd8a8a5e4557" => :mountain_lion
    sha1 "d39f42b173264a333e0d90298713e280ec892452" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    system "#{bin}/boxdumper", "-v"
    system "#{bin}/muxer", "-v"
    system "#{bin}/remuxer", "-v"
    system "#{bin}/timelineeditor", "-v"
  end
end
