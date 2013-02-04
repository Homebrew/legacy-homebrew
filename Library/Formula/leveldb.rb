require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.9.0.tar.gz'
  sha1 '4d832277120912211998a2334fb975b995d51885'

  depends_on 'snappy' => :build

  def install
    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.9' => 'libleveldb.1.9.dylib'
    lib.install_symlink lib/'libleveldb.1.9.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.9.dylib' => 'libleveldb.1.dylib'
  end
end
