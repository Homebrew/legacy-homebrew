class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/"
  url "http://www.creytiv.com/pub/baresip-0.4.13.tar.gz"
  sha256 "4f02079ae58085e61bb9363adc7139ead5865e3c032e274ba598954b19bbcdd6"

  bottle do
    sha256 "809e7ae4b309ce44e82862053683432bd0a3ac51ec76d210fa25178c0880c1c3" => :yosemite
    sha256 "6fbc01745eaa8e433912b82d35a705fbb842c141c716797af333e014edf0533f" => :mavericks
    sha256 "172b16460258452657481454f86021bf95c7255b539336ac490c27f2c31817b7" => :mountain_lion
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
    system "#{bin}/baresip", "-t"
  end
end
