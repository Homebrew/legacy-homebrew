require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-2.1.2.tar.gz'
  sha1 '3b189a3a188eef22149b08ed625368c5cd15c363'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'msgpack'

  def install
    # ZeroMQ is an optional dependency that will be auto-detected unless we disbale it
    system "./configure", "--prefix=#{prefix}", "--with-zlib", "--disable-zeromq"
    system "make install"
  end
end
