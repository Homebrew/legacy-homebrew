require "formula"

class SuomiMalagaVoikko < Formula
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.16.tar.gz"
  sha1 "5d9310f8150b8d2b559d5e7c27829e2fd6125dfb"

  depends_on "malaga"

  def install
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end
end
