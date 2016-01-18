class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.4.7.tar.gz"
  sha256 "5d084f5ee17b839680ab6b978357c095c2a85d04bdf61fa03192019e3435954e"

  bottle do
    cellar :any
    sha256 "c7a84c2c501d6affa3860e21c266393f91d1deb4686b2e58f884f6f52b273f02" => :el_capitan
    sha256 "39cfeb55d8c301e2cad58d361ced4e90a0ff43c6c19e335ffd84382843bdb3a1" => :yosemite
    sha256 "e382810be23c866dbf53f20e527566b99d0cbfbd67605adb537960b79c8c6136" => :mavericks
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
