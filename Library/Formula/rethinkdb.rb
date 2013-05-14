require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.4.5.tgz'
  sha1 '3e9f8472cb70f0a712be92c0a2c52e4f299f4bd7'

  depends_on 'boost'
  depends_on 'v8'
  depends_on 'protobuf' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install-osx"
  end
end
