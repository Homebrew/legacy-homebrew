require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.14.0.tar.gz'
  sha1 '641d54df4aaf7ee569ae003cfbdb888ebdee0d7f'

  bottle do
    cellar :any
    sha1 '5cc0089f4f609134b4bfc9c1e24ead21ff819ab9' => :mavericks
    sha1 '61fa15138563d390443a81e712cffd45ab28b1d1' => :mountain_lion
    sha1 'e1722018f88c967cf3c65a29cdd03f828e9da595' => :lion
  end

  depends_on 'snappy'

  def install
    system 'make'
    system 'make', 'leveldbutil'

    include.install 'include/leveldb'
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.14' => 'libleveldb.1.14.dylib'
    lib.install_symlink lib/'libleveldb.1.14.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.14.dylib' => 'libleveldb.1.dylib'
  end
end
