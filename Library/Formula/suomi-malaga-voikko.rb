require "formula"

class SuomiMalagaVoikko < Formula
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.17.tar.gz"
  sha1 "e3d3947b06f3ac2b13eaa2236c328b788c7d6bb8"

  bottle do
    cellar :any
    sha1 "335762aa767e4ae16fbc907e8b74e3275ce8b750" => :mavericks
    sha1 "1c0b38b5ed014bdbdf8dbf2f5cb4316eef065424" => :mountain_lion
    sha1 "3336b5cc97746af63b96112d7f83f76f68eeb714" => :lion
  end

  depends_on "malaga"

  def install
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
