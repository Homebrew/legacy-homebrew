require 'formula'

class Leveldb < Formula
  homepage 'http://code.google.com/p/leveldb/'
  head 'http://leveldb.googlecode.com/svn/trunk/', :using => :svn

  depends_on 'snappy' => :optional

  def install
    system "make"
    prefix.install Dir['include']
    lib.install ['libleveldb.a']
  end
end
