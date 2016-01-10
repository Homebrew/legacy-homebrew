class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "9d55ca647f6f00bebdb6d9499c6607b71cfa8f42b6539bc0d17a472108f89e60"
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
