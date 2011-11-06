require 'formula'

class Ldns < Formula
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.10.tar.gz'
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  sha1 '7798a32c6f50a4fb7d56ddf772163dc1cb79c1a4'

  def install
      system "./configure", "--prefix=#{prefix}", "--disable-gost"
      system "make"
      system "make install"

      Dir.chdir('drill') do
        system "./configure", "--prefix=#{prefix}", "--with-ldns=#{prefix}"
        system "make"
        system "make install"
      end

      Dir.chdir('examples') do
        system "./configure", "--prefix=#{prefix}", "--with-ldns=#{prefix}", "--disable-gost"
        system "make"
        system "make install"
      end
  end
end
