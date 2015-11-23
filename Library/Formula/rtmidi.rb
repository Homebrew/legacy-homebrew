class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "https://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://github.com/thestk/rtmidi/archive/2.1.0.tar.gz"
  sha256 "52e6822fc413d5d3963c5b7bfe412ed69233bb81a7f04d6097f5b56aafa28934"

  bottle do
    cellar :any
    sha256 "2abe3e651405114e4a667eb1d3491be8fde15a62d7605622449a92a6ab78a443" => :yosemite
    sha256 "4516090de14fa3f4caa5e7bc277f4d64d269dcad32488cc195395572803e6186" => :mavericks
    sha256 "329d88e5bbe8d96549707288b9599213cc16f9df64880d6de035fc0f50c10d14" => :mountain_lion
  end

  depends_on "autoconf" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "librtmidi.a"
    lib.install Dir["*.a", "*.dylib"]
    include.install Dir["*.h"]
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "RtMidi.h"
      int main(int argc, char **argv, char **env) {
        RtMidiIn midiin;
        RtMidiOut midiout;
        std::cout << "Input ports: " << midiin.getPortCount() << "\\n"
                  << "Output ports: " << midiout.getPortCount() << "\\n";
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lrtmidi", "-o", "test"
    system "./test"
  end
end
