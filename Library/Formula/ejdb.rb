require 'formula'

class Ejdb < Formula
  homepage 'http://ejdb.org/'
  url 'https://github.com/Softmotions/ejdb/archive/v1.1.23.tar.gz'
  sha1 '00ca2c150b2988747ad7b15148c2d624253026c5'

  def install
    system "cd tcejdb && ./configure --prefix=#{prefix} --disable-debug && make"
    system "cd tcejdb && make install"
  end
end
