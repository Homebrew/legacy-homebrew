require "formula"

class OpenalSoft < Formula
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.16.0.tar.bz2"
  sha1 "f70892fc075ae726320478c0179f7011fea0d157"

  bottle do
    cellar :any
    sha1 "f447363850f71bb2332914cc9915e757cca0556f" => :mavericks
    sha1 "732aba3be7edf074d9dd619cca10d4108db0b099" => :mountain_lion
    sha1 "03d64490aaab809fa4095401dbb8508b98c2b99f" => :lion
  end

  option :universal

  depends_on "cmake" => :build

  # llvm-gcc does not support the alignas macro
  # clang 4.2's support for alignas is incomplete
  fails_with :llvm
  fails_with(:clang) { build 425 }

  def install
    ENV.universal_binary if build.universal?
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "AL/al.h"
      #include "AL/alc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lopenal"
  end
end
