require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.4.0.tar.gz'
  md5 'f5babf2cfe0292608c3665b3f2770376'
  
  depends_on 'snappy' => :build

  def install
    system "make"
    include.install "include/leveldb"

    mv "libleveldb.dylib.1.4", "libleveldb.1.4.dylib"
    rm "libleveldb.dylib"
    ln_s "libleveldb.1.4.dylib", "libleveldb.dylib"

    lib.install "libleveldb.a", "libleveldb.1.4.dylib", "libleveldb.dylib"
  end

  def test
    %w(
      libleveldb.a
      libleveldb.dylib
      libleveldb.1.4.dylib
    ).each do |file|
      File.exists? "#{prefix}/lib/#{file}"
    end
  end
end
