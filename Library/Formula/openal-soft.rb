require "formula"

class OpenalSoft < Formula
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.15.1.tar.bz2"
  sha1 "a0e73a46740c52ccbde38a3912c5b0fd72679ec8"

  bottle do
    cellar :any
    sha1 "44f4eae635fecdc2bebfc971e1d708e660781f1b" => :mavericks
    sha1 "d360e2481ac65b746f3d5f6b4f5c942a444da2d0" => :mountain_lion
    sha1 "dd626bbe9640d591867709ac465652f6618d3457" => :lion
  end

  depends_on "cmake" => :build

  def install
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
