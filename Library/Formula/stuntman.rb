class Stuntman < Formula
  desc "Implementation of the STUN protocol"
  homepage "http://www.stunprotocol.org/"
  url "http://www.stunprotocol.org/stunserver-1.2.7.tgz"
  sha256 "51415bf83339f059c6a65bbece9b758e3f198cb86063a0f1b4f12d825c87640e"
  head "https://github.com/jselbie/stunserver.git"

  bottle do
    cellar :any
    sha1 "cba61cc3db211fd4f2b7c8e07284fdfbb4151553" => :mavericks
    sha1 "bf4bc85266aaabc0247860cee0695a7fe93a0d5b" => :mountain_lion
    sha1 "e3e3efbf5fa4160d17e1786c0d30ec65e51cb262" => :lion
  end

  depends_on "boost" => :build

  def install
    system "make"
    bin.install "stunserver", "stunclient", "stuntestcode"
  end

  test do
    system "#{bin}/stuntestcode"
  end
end
