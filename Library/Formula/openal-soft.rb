class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.17.2.tar.bz2"
  sha256 "a341f8542f1f0b8c65241a17da13d073f18ec06658e1a1606a8ecc8bbc2b3314"
  head "http://repo.or.cz/openal-soft.git"

  bottle do
    cellar :any
    sha256 "915bd92597553f3f005071fa85e08e2947fd545a4af4b5dcf514ea79320d7a99" => :el_capitan
    sha256 "643cd46bc9aa8fdf9c85aaa374d71d2dd6d18abeb674445f49d829f61dc82c4e" => :yosemite
    sha256 "819886eab2909ebcff2edb16c39ede1800ec987e193b0fdfce8d4047636fff17" => :mavericks
  end

  keg_only :provided_by_osx, "OS X provides OpenAL.framework."

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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end
