class Mongoose < Formula
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/5.6.tar.gz"
  sha256 "cc2557c7cf9f15e1e691f285a4c6c705cc7e56cb70c64cb49703a428a0677065"

  def install
    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib"
    include.install "mongoose.h"
    lib.install "libmongoose.dylib"
    share.install "examples", "docs", "jni"
  end

  test do
    system ENV.cc, "#{share}/examples/hello_world/hello_world.c", "-o", "hello_world", "-lmongoose"
  end
end
