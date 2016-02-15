class Ucl < Formula
  desc "Data compression library with small memory footprint"
  homepage "http://www.oberhumer.com/opensource/ucl/"
  url "http://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz"
  sha256 "b865299ffd45d73412293369c9754b07637680e5c826915f097577cd27350348"

  bottle do
    cellar :any_skip_relocation
    sha256 "d56b0d36a68a2bc558742eac0c6632612180797cc45520389b5d87f09c23b1bd" => :el_capitan
    sha256 "32a54309c092854fc5a4a443a1e9d33fb677ff257d983ea7d5b0eb7bb90d3b2e" => :yosemite
    sha256 "3c334012766dce80dac49d279be1be1ae4a1fc5df188cc19a25ba1bec84305a9" => :mavericks
    sha256 "4190f1602c52b934a93581741fcccba8dad4e8dc4f478342d71b1b564cd62834" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      // simplified version of
      // https://github.com/korczis/ucl/blob/master/examples/simple.c
      #include <stdio.h>
      #include <ucl/ucl.h>
      #include <ucl/uclconf.h>
      #define IN_LEN      (128*1024L)
      #define OUT_LEN     (IN_LEN + IN_LEN / 8 + 256)
      int main(int argc, char *argv[]) {
          int r;
          ucl_byte *in, *out;
          ucl_uint in_len, out_len, new_len;

          if (ucl_init() != UCL_E_OK) { return 4; }
          in = (ucl_byte *) ucl_malloc(IN_LEN);
          out = (ucl_byte *) ucl_malloc(OUT_LEN);
          if (in == NULL || out == NULL) { return 3; }

          in_len = IN_LEN;
          ucl_memset(in,0,in_len);

          r = ucl_nrv2b_99_compress(in,in_len,out,&out_len,NULL,5,NULL,NULL);
          if (r != UCL_E_OK) { return 2; }
          if (out_len >= in_len) { return 0; }
          r = ucl_nrv2b_decompress_8(out,out_len,in,&new_len,NULL);
          if (r != UCL_E_OK && new_len == in_len) { return 1; }
          ucl_free(out);
          ucl_free(in);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
