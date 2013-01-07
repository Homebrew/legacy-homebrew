require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://www.unbound.net/downloads/unbound-1.4.19.tar.gz'
  sha256 '47e681cf2489cdbad9c9687d579e9b052dceada8f9a720ba447689246aaeeadd'

  depends_on 'ldns'

  def install
    # gost requires OpenSSL >= 1.0.0, and support built into ldns
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gost"
    system "make install"
  end
end
