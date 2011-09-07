require 'formula'

class Maatkit < Formula
  url 'http://maatkit.googlecode.com/files/maatkit-7540.tar.gz'
  homepage 'http://code.google.com/p/maatkit/'
  sha1 '206f50a29ad7bf6a37e24b8e72a12331895b60aa'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
