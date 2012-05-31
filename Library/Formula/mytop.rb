require 'formula'

class Mytop < Formula
  homepage 'http://jeremy.zawodny.com/mysql/mytop/'
  url 'http://jeremy.zawodny.com/mysql/mytop/mytop-1.6.tar.gz'
  md5 '4127c3e486eb664fed60f40849372a9f'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make test install"
  end
end
