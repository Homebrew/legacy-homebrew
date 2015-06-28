class Rtmidi < Formula
  desc "C++ classes that provide a common API for realtime MIDI input/output"
  homepage "http://www.music.mcgill.ca/~gary/rtmidi/"
  url "https://github.com/thestk/rtmidi/archive/2.1.0.tar.gz"
  sha256 "52e6822fc413d5d3963c5b7bfe412ed69233bb81a7f04d6097f5b56aafa28934"

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
