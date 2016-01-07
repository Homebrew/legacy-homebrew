class Xmake < Formula
  desc "The Automatic Cross-platform Build Tool"
  homepage "https://github.com/waruqi/xmake"
  url "https://github.com/waruqi/xmake/archive/v1.0.4.tar.gz"
  mirror "http://tboox.net/release/xmake/xmake-v1.0.4.tar.gz"
  sha256 "317c29d9267567963a25b4fa69a02ac1568153717644db7492659006b2ea9389"
  head "https://github.com/waruqi/xmake.git"

  def install
    # compile xmake core
    cd "./core"
    system "make", "f", "DEBUG=n"
    system "make", "r"
    system "make", "i"
    cd ".."

    # install the xmake core file
    cp "./core/bin/demo.pkg/bin/mac/x64/demo.b", prefix+"xmake"
    chmod 0755, prefix+"xmake"

    # install the xmake directory
    share.mkdir
    (share/"xmake").mkdir
    (share/"xmake").install Dir["./xmake/*"]

    # install the xmake loader
    (bin/"xmake").write("#!/bin/bash\nexport XMAKE_PROGRAM_DIR=#{share}/xmake\n#{prefix}/xmake $verbose \"\$@\"")
    chmod 0755, bin/"xmake"
  end

  test do
    (testpath/"xmake.lua").write("")
    system "#{bin}/xmake"
  end
end
