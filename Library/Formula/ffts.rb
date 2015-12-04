class Ffts < Formula
  desc "C library that computes the discrete Fourier transform"
  homepage "http://anthonix.com/ffts/"
  url "http://anthonix.com/ffts/releases/ffts-0.7.tar.gz"
  sha256 "6362e498e5aa241661cfe9060153076b78e300a5d3c365997ba6ac2f637df3ff"
  head "https://github.com/anthonix/ffts.git"

  bottle do
    cellar :any
    sha256 "1f5247eaac6427f34ac4ad8155fd29841d4adea671f21b264c679d2adbdb22ef" => :yosemite
    sha256 "f22fd4ecf695fe69df9177f68e2d880fcdc5c37201ded5d29c39760de3b787db" => :mavericks
    sha256 "9057a22063635a12c8645f1a63f282d548df2dabd9e67114f3036e2a43cf2836" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sse",
                          "--enable-single"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ffts/ffts.h>
      #define align(x) __attribute__((aligned(x)))
      int main(void) {
          const size_t    n         = 8;
          float align(32) input[n]  = {0.0, };
          float align(32) output[n];
          ffts_plan_t*    plan      = ffts_init_1d(n, 1);
          ffts_execute(plan, input, output);
          ffts_free(plan);
      }
    EOS
    system ENV.cc, "test.c", "-lffts", "-o", "test"
    system "./test"
  end
end
