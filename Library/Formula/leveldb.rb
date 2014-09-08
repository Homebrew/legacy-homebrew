require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.15.0.tar.gz'
  sha1 '74b70a1156d91807d8d84bfdd026e0bb5acbbf23'
  revision 1

  bottle do
    cellar :any
    sha1 "c376b1ae47db56d9203b79ce2e220a7793c2366f" => :mavericks
    sha1 "2bba417ededa2d85f266990f8f87f3ada7035354" => :mountain_lion
    sha1 "48adc08cdfc9c156a045913ce338e9f82262d2d4" => :lion
  end

  depends_on 'snappy'

  def install
    system 'make'
    system 'make', 'leveldbutil'

    include.install 'include/leveldb'
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.15' => 'libleveldb.1.15.dylib'
    lib.install_symlink lib/'libleveldb.1.15.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.15.dylib' => 'libleveldb.1.dylib'
    system "install_name_tool", "-id", "#{lib}/libleveldb.1.dylib", "#{lib}/libleveldb.1.15.dylib"
  end
end
