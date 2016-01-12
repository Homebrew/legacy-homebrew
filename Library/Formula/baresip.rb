class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/baresip.html"
  url "http://www.creytiv.com/pub/baresip-0.4.16.tar.gz"
  sha256 "e6a0b93fc51a974b738ff3a12e1fbc508c8d307880aa03b19b61a541e3694911"

  bottle do
    revision 1
    sha256 "186c0d745ca874799b2b5b9ddab33c3c39b9ab2f95b8ac320b5fd60aecab4fa8" => :el_capitan
    sha256 "d657b4e1c855a9d39cab339d9eda517fff2625c77d7c3b6ec0739d975cbdc815" => :yosemite
    sha256 "7be2d9852b453a11da9b81cd6e663c29b7d2a36a9c8fbeca3894e00d0e075f34" => :mavericks
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
