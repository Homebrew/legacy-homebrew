require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.7.0.tar.gz'
  sha1 '82332ac97d48ad5da02aab4785658c06d0351be1'

  depends_on 'snappy' => :build

  def install
    system "make"
    include.install "include/leveldb"
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.7' => 'libleveldb.1.7.dylib'
    lib.install_symlink lib/'libleveldb.1.7.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.7.dylib' => 'libleveldb.1.dylib'
  end
end
