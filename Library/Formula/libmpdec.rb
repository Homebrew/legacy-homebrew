class Libmpdec < Formula
  desc "Library for arbitrary precision decimal floating point arithmetic."
  homepage "http://www.bytereef.org/mpdecimal/index.html"
  url "http://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.4.2.tar.gz"
  sha256 "83c628b90f009470981cf084c5418329c88b19835d8af3691b930afccb7d79c7"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <mpdecimal.h>

      int main()
      {
        mpd_context_t ctx;
        mpd_t *a, *b, *result;
        mpd_defaultcontext(&ctx);

        result = mpd_new(&ctx);
        a = mpd_new(&ctx);
        b = mpd_new(&ctx);

        mpd_set_string(a, "0.1234", &ctx);
        mpd_set_string(b, "0.12340000", &ctx);

        mpd_compare(result, a, b, &ctx);
        int r = mpd_get_i32(result, &ctx);
        assert(r == 0);

        mpd_del(a);
        mpd_del(b);
        mpd_del(result);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmpdec", "-o", "test"
    system "./test"
  end
end
