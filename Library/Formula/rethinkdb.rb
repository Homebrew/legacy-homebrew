require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.4.0.tgz'
  sha1 'cc4f75f92aace746e5ea5fce68c0e831f6327890'

  depends_on 'boost'
  depends_on 'v8'
  depends_on 'protobuf' => :build

  def install
    system "./configure --prefix=#{prefix}"
    system "make install-osx"
  end
end
