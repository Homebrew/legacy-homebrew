require 'formula'

class Ldns < Formula
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.5.tar.gz'
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  sha1 '267eea7a8a7af5a373aed6c26084ed9e43bddc4d'

  def install
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
      Dir.chdir('drill') do
        system "./configure", "--prefix=#{prefix}", "--with-ldns=#{prefix}"
        system "make"
        system "make install"
      end
  end
end
