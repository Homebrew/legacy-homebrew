require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-3.0.8.tar.gz'
  sha1 '00f226d6c85d21a71107b398322bf86389db9432'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'msgpack'

  def install
    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-zeromq"
    system "make install"
  end
end
