require 'formula'

class Leveldb < Formula
  url 'https://code.google.com/p/leveldb.git', :using => :git
  homepage 'https://code.google.com/p/leveldb/'
  md5 '11baeca3c91343248de45a3927d0736e'
  version '1.1'
  depends_on 'snappy' => :build

  def install
    system "bash build_detect_platform"
    system "make"
    lib.install "libleveldb.a"
    include.install "include/leveldb"
  end

  def test
    File.exists? "#{prefix}/lib/libleveldb.a"
  end
end

