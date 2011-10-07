require 'formula'

class Mytop < Formula
  url 'http://jeremy.zawodny.com/mysql/mytop/mytop-1.6.tar.gz'
  homepage 'http://jeremy.zawodny.com/mysql/mytop/'
  md5 '4127c3e486eb664fed60f40849372a9f'

  depends_on 'DBD::mysql' => :perl

  def install
    # needs DBD:mysql
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make test install"
  end
end
