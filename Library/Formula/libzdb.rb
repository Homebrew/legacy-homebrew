require 'formula'

class Libzdb < Formula
  homepage 'http://tildeslash.com/libzdb/'
  url 'http://tildeslash.com/libzdb/dist/libzdb-2.12.tar.gz'
  sha1 '4d34be255afddbd025b2f60c5cd11b4389b5c88c'

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
