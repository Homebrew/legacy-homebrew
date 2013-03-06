require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-3.0.1.tar.gz'
  sha1 '50e17168e094f4ab5d1aab0c835451e437929544'

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
