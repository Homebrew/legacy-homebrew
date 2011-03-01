require 'formula'

class Hiredis <Formula
  url 'https://github.com/antirez/hiredis/tarball/v0.9.2'
  head 'git://github.com/antirez/hiredis.git'
  homepage 'https://github.com/antirez/hiredis'
  version '0.9.2'
  sha1 '2a258b2bc56958144307df13a5ecf6692c637ee3'

  def install
    fails_with_llvm "Can't figure out architecture type", :build => 2333
    system "make PREFIX=#{prefix}"
    system "make install PREFIX=#{prefix}"
  end
end
