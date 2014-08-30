require "formula"

class Librem < Formula
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.4.6.tar.gz"
  sha1 "9698b48aee5e720e56440f4c660d8bd4dbb7f8fa"

  bottle do
    cellar :any
    sha1 "e1089e53d13bd264d8a6b95cce0401c7ae5b6aed" => :mavericks
    sha1 "8da4a993fa287e444b649b045fdfb48718b733d5" => :mountain_lion
    sha1 "cb6ace233af76a21ef463f005d13121686ffebeb" => :lion
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
