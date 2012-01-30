require 'formula'

class Ldns < Formula
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.12.tar.gz'
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  sha1 '1d61df0f666908551d5a62768f77d63e727810aa'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-gost", "--with-drill", "--with-examples"
      system "make"
      system "make install"
  end
end
