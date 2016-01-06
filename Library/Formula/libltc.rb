class Libltc < Formula
  desc "POSIX-C Library for handling Linear/Logitudinal Time Code (LTC)"
  homepage "https://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.2.0/libltc-1.2.0.tar.gz"
  sha256 "a0be3026525fc066246154afab18860a9291a0853651fcafdd37428c1a171ff3"

  bottle do
    cellar :any
    revision 1
    sha256 "d564cdf6f1790cf144426fb2e3adb8e3a5caa9b519f4fa72a994ee416f118ba3" => :yosemite
    sha256 "f29db88c6858b07e9273974a8c4633bd2ceb302ba033c41cfe31f171fa02c9d0" => :mavericks
    sha256 "a3e44438c81e84aa4bfb3e1e86190cd4f8271d490a9ee7cea64ecd18936e070e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      // stripped-down copy of:
      // https://raw.githubusercontent.com/x42/libltc/87d45b3/tests/example_encode.c
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <ltc.h>

      int main(int argc, char **argv) {
        FILE* file;
        double length = 2;
        double fps = 25;
        double sample_rate = 48000;
        char *filename = "#{testpath}/foobar";
        int vframe_cnt;
        int vframe_last;
        int total = 0;
        ltcsnd_sample_t *buf;
        LTCEncoder *encoder;
        SMPTETimecode st;

        const char timezone[6] = "+0100";
        strcpy(st.timezone, timezone);
        st.years = 8;
        st.months = 12;
        st.days = 31;
        st.hours = 23;
        st.mins = 59;
        st.secs = 59;
        st.frame = 0;

        file = fopen(filename, "wb");
        if (!file) {
          fprintf(stderr, "Error: can not open file '%s' for writing.\\n", filename);
          return 1;
        }

        encoder = ltc_encoder_create(sample_rate, fps,
            fps==25?LTC_TV_625_50:LTC_TV_525_60, LTC_USE_DATE);
        ltc_encoder_set_timecode(encoder, &st);

        vframe_cnt = 0;
        vframe_last = length * fps;

        while (vframe_cnt++ < vframe_last) {
          int byte_cnt;
          for (byte_cnt = 0 ; byte_cnt < 10 ; byte_cnt++) {
            ltc_encoder_encode_byte(encoder, byte_cnt, 1.0);

            int len;
            buf = ltc_encoder_get_bufptr(encoder, &len, 1);

            if (len > 0) {
              fwrite(buf, sizeof(ltcsnd_sample_t), len, file);
              total+=len;
            }
          }

          ltc_encoder_inc_timecode(encoder);
        }
        fclose(file);
        ltc_encoder_free(encoder);

        printf("Done: wrote %d samples to '%s'\\n", total, filename);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lltc", "-lm", "-o", "test"
    system "./test"
    assert (testpath/"foobar").file?
  end
end
