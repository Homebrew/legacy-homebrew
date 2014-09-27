require "formula"

class OpenalSoft < Formula
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.16.0.tar.bz2"
  sha1 "f70892fc075ae726320478c0179f7011fea0d157"

  bottle do
  end

  option :universal

  depends_on "cmake" => :build

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
