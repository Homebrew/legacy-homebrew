class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "adb4714ce89d6c9fcb24f7ae641ac9221d4172d728add441e29a6453a908f76f"
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
