class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-1.0.4.tar.gz"
  sha256 "79c521e6096b213c36184d27c9096e6db43c70c1d58c7bfd67a19951ccdce7c0"

  def install
    system "./install", prefix
  end

  test do
    (testpath/"xmake.lua").write("")
    system "#{bin}/xmake"
  end
end
