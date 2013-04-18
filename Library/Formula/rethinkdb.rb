require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.4.2.tgz'
  sha1 'dee3cb57a084e3a9737e8273dd14931a247bd935'

  depends_on 'boost'
  depends_on 'v8'
  depends_on 'protobuf' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install-osx"
  end
end
