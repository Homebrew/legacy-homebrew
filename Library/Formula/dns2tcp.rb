require 'formula'

class Dns2tcp < Formula
  homepage 'http://www.hsc.fr/ressources/outils/dns2tcp/index.html.en'
  url 'http://www.hsc.fr/ressources/outils/dns2tcp/download/dns2tcp-0.5.2.tar.gz'
  md5 '51c5dc69f5814c2936ce6832217d292d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
