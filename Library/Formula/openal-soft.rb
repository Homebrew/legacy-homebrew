class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.16.0.tar.bz2"
  sha256 "2f3dcd313fe26391284fbf8596863723f99c65d6c6846dccb48e79cadaf40d5f"

  bottle do
    cellar :any
    revision 1
    sha256 "4f31acb42ba76c79984e7ef0c5be5cbc63a6bff524516b3f67d2fb363363ec64" => :yosemite
    sha256 "e0378ccb0dee6eca4d505ba313512ed12b44f6a58525418a544bce681fa3ad1b" => :mavericks
    sha256 "b190c7c847f976b7d4938ea84356baa7225b63748c890af151150089f145ec6a" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "portaudio" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "qt" => :optional

  # llvm-gcc does not support the alignas macro
  # clang 4.2's support for alignas is incomplete
  fails_with :llvm
  fails_with(:clang) { build 425 }

  def install
    ENV.universal_binary if build.universal?

    # Please don't reenable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = std_cmake_args
    args << "-DALSOFT_EXAMPLES=OFF"

    args << "-DALSOFT_BACKEND_PORTAUDIO=OFF" if build.without? "portaudio"
    args << "-DALSOFT_BACKEND_PULSEAUDIO=OFF" if build.without? "pulseaudio"
    args << "-DALSOFT_MIDI_FLUIDSYNTH=OFF" if build.without? "fluid-synth"

    system "cmake", ".", *args
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
