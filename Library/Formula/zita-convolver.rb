class ZitaConvolver < Formula
  desc "fast, partitioned convolution engine library"
  homepage "http://kokkinizita.linuxaudio.org/linuxaudio/"
  url "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/zita-convolver-3.1.0.tar.bz2"
  sha256 "bf7e93b582168b78d40666974460ad8142c2fa3c3412e327e4ab960b3fb31993"

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
