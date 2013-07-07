require 'formula'

class Mytop < Formula
  homepage 'http://jeremy.zawodny.com/mysql/mytop/'
  url 'http://jeremy.zawodny.com/mysql/mytop/mytop-1.6.tar.gz'
  sha1 'e1485115ca3a15e79f7811bdc1cfe692aa95833f'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make test install"
  end
end
