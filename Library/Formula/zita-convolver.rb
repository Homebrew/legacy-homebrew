class ZitaConvolver < Formula
  desc "fast, partitioned convolution engine library"
  homepage "http://kokkinizita.linuxaudio.org/linuxaudio/"
  url "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-3.1.0.tar.bz2"
  sha256 "bf7e93b582168b78d40666974460ad8142c2fa3c3412e327e4ab960b3fb31993"

  bottle do
    cellar :any
    sha256 "04d09876460f0e255618113fc69a7f30093f034bdb695990c2f2850f8e31afd5" => :el_capitan
    sha256 "c6676066535c069104449a12324299a7361435f46fc6983ed0e28b85b585e6af" => :yosemite
    sha256 "7419429613f3fa768f8f0b86a9bc6928f346d97270e0d701f653f195b29dcdd4" => :mavericks
  end

  depends_on "fftw"

  def install
    cd "libs" do
      system "make", "-f", "Makefile-osx", "install", "PREFIX=#{prefix}", "SUFFIX="
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <zita-convolver.h>

    int main() {
      return zita_convolver_major_version () != ZITA_CONVOLVER_MAJOR_VERSION;
    }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzita-convolver", "-o", "test"
    system "./test"
  end
end
