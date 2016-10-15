require 'formula'

class SuomiMalagaVoikko < Formula
  homepage 'http://voikko.puimula.org/'
  url 'http://www.puimula.org/voikko-sources/suomi-malaga/suomi-malaga-1.15.tar.gz'
  sha1 '92f80a2115a6e69b97a68992584b43618dac4b61'

  depends_on 'malaga'

  def install
    system "make", "voikko"
    system "make", "voikko-install", "DESTDIR=#{lib}/voikko"
  end

end
