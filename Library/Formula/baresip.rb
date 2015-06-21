class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "http://www.creytiv.com/"
  url "http://www.creytiv.com/pub/baresip-0.4.13.tar.gz"
  sha256 "4f02079ae58085e61bb9363adc7139ead5865e3c032e274ba598954b19bbcdd6"

  bottle do
    sha1 "bbbd13065696d79cb97d346ef5df38f0f8ad5c81" => :yosemite
    sha1 "2805c3ab5c7bac73d7eaf54884832cfd5b0dd15b" => :mavericks
    sha1 "aca67e94e7b6aa4fd8de6e6433332a968290b58b" => :mountain_lion
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
