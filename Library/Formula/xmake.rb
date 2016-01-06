class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.zip"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.zip"
  sha256 "bd1edfeabe94c78b6cf50a3d3f9c109984c417baef5072712d2b7a461d884b41"
  head "https://github.com/waruqi/xmake.git"

  def install
    system "./install", prefix
  end

  test do
    (testpath/"xmake.lua").write("")
    system "#{bin}/xmake"
  end
end
