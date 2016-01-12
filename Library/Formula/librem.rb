class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.4.7.tar.gz"
  sha256 "5d084f5ee17b839680ab6b978357c095c2a85d04bdf61fa03192019e3435954e"

  bottle do
    cellar :any
    revision 1
    sha256 "a46c034ef3e81aeef5ad3e381e14d35025fe0c3a80923ab64497c2e74bc8ca5e" => :yosemite
    sha256 "c2213e486027d0e98812f0c187252ca1d70e1a4348c0d5c2e476777f999c17bf" => :mavericks
    sha256 "04407afbfe65e16d86c61dae8cdc0f607275d08023e67d3534b49286955706e5" => :mountain_lion
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
    (testpath/"test.c").write <<-EOS.undent
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
