require 'brewkit'

class Couchdb <Formula
  @url='http://apache.multihomed.net/couchdb/0.9.1/apache-couchdb-0.9.1.tar.gz'
  @homepage='http://couchdb.apache.org/'
  @md5='9583efae5adfb3f9043e970fef825561'

  def deps
    LibraryDep.new 'spidermonkey'
    LibraryDep.new 'icu4c'
    BinaryDep.new 'erlang'
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
