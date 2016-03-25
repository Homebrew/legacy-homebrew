class Cubeb < Formula
  desc "Cross-platform audio library."
  homepage "https://github.com/kinetiknz/cubeb"
  url "https://github.com/kinetiknz/cubeb/archive/cubeb-0.2.tar.gz"
  sha256 "cac10876da4fa3b3d2879e0c658d09e8a258734562198301d99c1e8228e66907"

  head "https://github.com/kinetiknz/cubeb.git"

  bottle do
    cellar :any
    sha256 "f7e738b374bb07e1c420e56dfeb72caa814495b446c71d8158ef98c9b33d3a60" => :el_capitan
    sha256 "b3cff6ba7008cc764f94281f7759f5d6d2a09a3bdb92f5f6e93be7d6f3ec2405" => :yosemite
    sha256 "f239e3b4cc459b4e0e3f4630229242a351dc833dcb385e7badb16208a53f3265" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <cubeb/cubeb.h>

      #define TEST(test, msg) \
        if ((test)) { \
          printf("PASS: %s\\n", msg); \
        } else { \
          printf("FAIL: %s\\n", msg); \
          goto end; \
        }

      /* Dummy callbacks to use for audio stream test */
      static long data_callback(cubeb_stream *stream, void *user, void *buffer,
          long nframes) {
        return nframes;
      }
      static void state_callback(cubeb_stream *stream, void *user_ptr,
          cubeb_state state) {}

      int main() {
        int ret;
        cubeb *ctx;
        char const *backend_id;
        cubeb_stream *stream;
        cubeb_stream_params params;

        /* Verify that the library initialises itself successfully */
        ret = cubeb_init(&ctx, "test_context");
        TEST(ret == CUBEB_OK, "initialse cubeb context");

        /* Verify backend id can be retrieved */
        backend_id = cubeb_get_backend_id(ctx);
        TEST(backend_id != NULL, "retrieve backend id");

        /* Verify that an audio stream gets opened successfully */
        params.format = CUBEB_SAMPLE_S16LE; /* use commonly supported      */
        params.rate = 48000;                /* parametrs, so that the test */
        params.channels = 1;                /* doesn't give a false fail   */
        ret = cubeb_stream_init(ctx, &stream, "test_stream", params, 100,
          data_callback, state_callback, NULL);
        TEST(ret == CUBEB_OK, "initialise stream");

      end:
        /* Cleanup and return */
        cubeb_stream_destroy(stream);
        cubeb_destroy(ctx);
        return 0;
      }
    EOS
    system "cc", "-o", "test", "#{testpath}/test.c", "-lcubeb"
    assert_no_match(/FAIL:.*/, shell_output("#{testpath}/test"),
                    "Basic sanity test failed.")
  end
end
