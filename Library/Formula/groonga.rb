require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.5.tar.gz'
  sha1 '0256c3e5e800e9763995b31e0864268e6a40678c'

  depends_on 'msgpack'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
