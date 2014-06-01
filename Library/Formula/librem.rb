require "formula"

class Librem < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.4.6.tar.gz"
  sha1 "9698b48aee5e720e56440f4c660d8bd4dbb7f8fa"

  depends_on "libre"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return NULL != vidfmt_name(VID_FMT_YUV420P);
      }
    EOS
    system ENV.cc, "test.c", "-lrem"
  end
end
