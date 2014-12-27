class Baresip < Formula
  homepage "http://www.creytiv.com/"
  url "http://www.creytiv.com/pub/baresip-0.4.12.tar.gz"
  sha1 "03f72e93ddf2f896568b092ee63203b1c6a19679"

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
    system "#{bin}/baresip", "-t"
  end
end
