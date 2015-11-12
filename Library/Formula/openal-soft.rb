class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  head "http://repo.or.cz/openal-soft.git"
  revision 1

  stable do
    url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.16.0.tar.bz2"
    sha256 "2f3dcd313fe26391284fbf8596863723f99c65d6c6846dccb48e79cadaf40d5f"

    # Fixed upstream already by:
    # http://repo.or.cz/openal-soft.git/commit/4b53d0e90cec08b4df06be22a9516f12ac5647f5
    # http://repo.or.cz/openal-soft.git/commit/6689c61ff474657109c5a73827b8733aba7dfd45
    depends_on MaximumMacOSRequirement => :yosemite
  end

  bottle do
    cellar :any
    sha256 "500f9689c526d26ffb39fafd03ade82f2e913b59c3c29ccc4698f3579db1eab8" => :yosemite
    sha256 "ecd9497afe87e2fdba9cb7d18efbc81548a06f0972f2a7a9ceda0056f97f5112" => :mavericks
    sha256 "e5e9b16266db4532c9387e4d87e5839cb1c6545065bc3b911ee8890fa5446e2f" => :mountain_lion
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

  keg_only :provided_by_osx, "OS X provides OpenAL.framework."

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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end
