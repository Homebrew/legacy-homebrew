class Chirp < Formula
  desc "CHIRP is a free, open-source tool for programming your amateur radio."
  homepage "http://chirp.danplanet.com/"
  url "http://trac.chirp.danplanet.com/chirp_daily/daily-20150702/chirp-daily-20150702.tar.gz"
  sha256 "41a5ae113bea27a284675ad5d95b45e4cd90f76ea2cd29050396d55bab5be433"

  depends_on "python"
  depends_on "pygtk"
  depends_on "libxml2" => "with-python"

  def install
    prefix.install Dir["*"]

    bin.install_symlink "#{prefix}/chirpw"
  end
end
