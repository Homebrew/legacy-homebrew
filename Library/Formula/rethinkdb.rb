require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.5.2.tgz'
  sha1 'de229816f17665c12f7c116fcbbc7a7a893b3a08'

  depends_on 'boost' => :build
  depends_on 'v8'

  def install
    system "./configure --prefix=#{prefix} --fetch protobuf"
    system "make"
    system "make install-osx"
  end
end
