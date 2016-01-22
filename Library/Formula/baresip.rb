class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.17.tar.gz"
  sha256 "de7e6ff0185290eb50f2956d81a0fcdcf2a2af76432f64f090dd7be5db53d680"

  bottle do
    sha256 "890831b7eab558c0b3233c2292c1665248a843b9d184e5c41cc1dc4720afe910" => :el_capitan
    sha256 "83bcbead6f69384cae76d042f674b7cf20cab898500317c117d44364503cede1" => :yosemite
    sha256 "52f74561840429dc2d44b2f38bb943a1c51b15016172f8a10c49acfaa1f1e7e6" => :mavericks
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
