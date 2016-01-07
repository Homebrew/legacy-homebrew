class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "c09e1e3c3c58641c6b39de169f1a1232d7556cf6820f805683991c58ec143880"
  head "https://github.com/waruqi/xmake.git"

  def install
    # install to the output directory first
    system "./install", "./output"

    # install the xmake directory
    share.mkdir
    (share/"xmake").mkdir
    (share/"xmake").install Dir["./xmake/*"]

    # install the xmake binary
    libexec.install "./output/share/xmake/xmake"
    bin.install Dir[libexec/"*"]
    bin.env_script_all_files(libexec, :XMAKE_PROGRAM_DIR =>"#{share}/xmake")
  end

  test do
    (testpath/"xmake.lua").write("")
    system "#{bin}/xmake"
  end
end
