require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-2.1.1.tar.gz'
  sha1 'd0ef04bf6b61dac6911308f5d9fa08bec888d765'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'msgpack'

  def install
    # ZeroMQ is an optional dependency that will be auto-detected unless we disbale it
    system "./configure", "--prefix=#{prefix}", "--with-zlib", "--disable-zeromq"
    system "make install"
  end
end
