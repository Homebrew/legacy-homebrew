class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "36307effa4251413f26b5c7af454269f0a06c891e1a4918a3801760b78d1a365"
  head "https://github.com/waruqi/xmake.git"

  def install
    system "./install", "output"
    pkgshare.install Dir["xmake/*"]
    bin.install "output/share/xmake/xmake"
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR =>"#{pkgshare}")
  end

  test do
    touch testpath/"xmake.lua"
    system "#{bin}/xmake"
  end
end
