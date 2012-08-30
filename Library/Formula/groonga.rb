require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.6.tar.gz'
  sha1 'a012a86d03e193f2ab029de2f1e09aa5f0e52bcf'

  depends_on 'msgpack'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
