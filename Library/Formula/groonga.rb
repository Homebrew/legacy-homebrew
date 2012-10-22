require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-2.0.7.tar.gz'
  sha1 '2bb69695d7a147cad00d1f6c7deebe81f277a99c'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'msgpack'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-zlib"
    system "make install"
  end
end
