require "formula"

class SuomiMalagaVoikko < Formula
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.16.tar.gz"
  sha1 "5d9310f8150b8d2b559d5e7c27829e2fd6125dfb"

  bottle do
    cellar :any
    sha1 "c11b9b0dc7c621fe5cc12f57390d5f3cbc0b9aa5" => :mavericks
    sha1 "5393ddb6f771831229d7ce422a312a8a5c1e879c" => :mountain_lion
    sha1 "1f0b8fec4b1d980fc186d9c296f8c760ceed1363" => :lion
  end

  depends_on "malaga"

  def install
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
