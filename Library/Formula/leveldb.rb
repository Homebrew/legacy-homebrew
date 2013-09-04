require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.13.0.tar.gz'
  sha1 '1da7c57b43415b3f486af31507302422e5854a20'

  depends_on 'snappy' => :build

  def install
    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.13' => 'libleveldb.1.13.dylib'
    lib.install_symlink lib/'libleveldb.1.13.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.13.dylib' => 'libleveldb.1.dylib'
  end
end
