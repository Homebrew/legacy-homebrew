class Restund < Formula
  desc "Modular STUN/TURN server"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/restund-0.4.11.tar.gz"
  sha256 "d4630dfb8777f12cc48ed118da0ea6445bc60e94ff916ab0ca5d436c74bdc2d7"

  bottle do
    cellar :any
    sha1 "ca362fc05e313ac4c2fc5fc761b3c502ff6c7ab9" => :yosemite
    sha1 "249056f251265110831e938cbb82cedbf294ec65" => :mavericks
    sha1 "ba868c60ec50840299ae1ae92e98e270ae9956e5" => :mountain_lion
  end

  depends_on "libre"

  # this patch is needed for restund to work on OSX, because it is
  # using select() for polling with max 1024 file descriptors.
  patch :p0 do
    url "http://www.creytiv.com/tmp/restund-homebrew.patch"
    sha256 "5890036319dd55e6522762a28022554024c849ce25e5c690364686e6a5571c93"
  end

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
    system "make", "config", "DESTDIR=#{prefix}",
                              "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    system "#{sbin}/restund", "-tdnf", "#{etc}/restund.conf"
  end
end
