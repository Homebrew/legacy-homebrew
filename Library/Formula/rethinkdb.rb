require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.4.1.tgz'
  sha1 '456effad3e1acb6afe57da3bed65ba4e0fa0a11c'

  depends_on 'boost'
  depends_on 'v8'
  depends_on 'protobuf' => :build

  def install
    system "./configure --prefix=#{prefix}"
    system "make install-osx"
  end
end
