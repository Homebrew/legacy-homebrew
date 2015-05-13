class SuomiMalagaVoikko < Formula
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.18.tar.gz"
  sha256 "83655d56aa8255d8926ad3bafa190b8d7da32a0e3ff12150dc2dac31c92c5b0d"

  head "https://github.com/voikko/corevoikko.git"

  bottle do
    cellar :any
    sha1 "335762aa767e4ae16fbc907e8b74e3275ce8b750" => :mavericks
    sha1 "1c0b38b5ed014bdbdf8dbf2f5cb4316eef065424" => :mountain_lion
    sha1 "3336b5cc97746af63b96112d7f83f76f68eeb714" => :lion
  end

  depends_on "malaga"

  def install
    Dir.chdir "suomimalaga" if build.head?
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
