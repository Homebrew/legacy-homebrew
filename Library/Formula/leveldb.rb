require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.11.0.tar.gz'
  sha1 '401914f2e6465ed008d92a11f4013a28fdf5f240'

  depends_on 'snappy' => :build

  def install
    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.11' => 'libleveldb.1.11.dylib'
    lib.install_symlink lib/'libleveldb.1.11.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.11.dylib' => 'libleveldb.1.dylib'
  end
end
