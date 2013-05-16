require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.5.0.tgz'
  sha1 '6e937fcf2c55d3a802037914f05c78ff0884af4d'

  depends_on 'boost' => :build
  depends_on 'v8'

  def install
    system "./configure --prefix=#{prefix} --fetch protobuf --fetch protoc"
    system "make"
    system "make install-osx"
  end
end
