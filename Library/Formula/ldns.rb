require 'formula'

class Ldns < Formula
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.11.tar.gz'
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  sha1 '2c4537eee39a1af63e8dde4f35498ce78c968c1f'

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
