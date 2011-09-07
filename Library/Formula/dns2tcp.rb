require 'formula'

class Dns2tcp < Formula
  url 'http://www.hsc.fr/ressources/outils/dns2tcp/download/dns2tcp-0.4.3.tar.gz'
  homepage 'http://www.hsc.fr/ressources/outils/dns2tcp/index.html.en'
  md5 'd2b322ee27f4ff53dfdad61aa2f42dd8'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
