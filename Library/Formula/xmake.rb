class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "0fb8b71ed1af4db2ad154a7a50386bf66de54f548a171c9d730c115641f4466f"
  head "https://github.com/waruqi/xmake.git"

  def install
    system "./install", prefix
  end

  test do
    (testpath/"xmake.lua").write("")
    system "#{bin}/xmake"
  end
end
