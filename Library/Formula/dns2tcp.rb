require 'formula'

class Dns2tcp < Formula
  homepage 'http://www.hsc.fr/ressources/outils/dns2tcp/index.html.en'
  url 'http://www.hsc.fr/ressources/outils/dns2tcp/download/dns2tcp-0.5.2.tar.gz'
  sha1 'b1de53800bbfda6d8c6f92e2844906b1b8a54af2'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
