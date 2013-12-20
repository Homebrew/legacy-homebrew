require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-3.1.0.tar.gz'
  sha1 '7d4ad3be8ade2b97ccf6790063b2b08d111daa59'

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
