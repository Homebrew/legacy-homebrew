require 'formula'

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.11.3.tar.gz'
  sha1 '0554b6a83e6767488bff58a7d0bd3ad024be092b'

  depends_on :postgresql => :recommended
  depends_on :mysql => :recommended
  depends_on 'sqlite' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--without-postgresql" if build.without? 'postgresql'
    args << "--without-mysql" if build.without? 'mysql'
    args << "--without-sqlite" if build.without? 'sqlite'

    system "./configure", *args
    system "make install"
  end
end
