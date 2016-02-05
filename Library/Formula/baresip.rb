class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.17.tar.gz"
  sha256 "de7e6ff0185290eb50f2956d81a0fcdcf2a2af76432f64f090dd7be5db53d680"

  bottle do
    sha256 "717509c81e9af80247cd6d47eb58db5ecb9f883675a28fe5d238d7db29c915e7" => :el_capitan
    sha256 "31c0a40f96fcade6002f8932cd19888807dc57d98e1884da913251435da98be2" => :yosemite
    sha256 "b4ec792f84dd1d59c69fe211c9e84ac9531012b155495f4964f5ea54b220f448" => :mavericks
  end

  depends_on "librem"
  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}",
                              "MOD_AUTODETECT=",
                              "USE_AVCAPTURE=1",
                              "USE_COREAUDIO=1",
                              "USE_G711=1",
                              "USE_OPENGL=1",
                              "USE_STDIO=1",
                              "USE_UUID=1"
  end

  test do
    system "#{bin}/baresip", "-f", "#{ENV["HOME"]}/.baresip", "-t"
  end
end
