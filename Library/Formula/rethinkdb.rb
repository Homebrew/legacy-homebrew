require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.4.4.tgz'
  sha1 '24f9b38b551e05ed560ca6ec85abd2276e29951e'

  depends_on 'boost'
  depends_on 'v8'
  depends_on 'protobuf' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install-osx"
  end
end
