require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.5.1-1.tgz'
  sha1 'bea52834a3a1d1f643947efe963907898f9d7c9e'

  depends_on 'boost' => :build
  depends_on 'v8'

  def install
    system "./configure --prefix=#{prefix} --fetch protobuf --fetch protoc"
    system "make"
    system "make install-osx"
  end
end
