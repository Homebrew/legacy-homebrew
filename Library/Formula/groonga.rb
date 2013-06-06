require 'formula'

class Groonga < Formula
  homepage 'http://groonga.org/'
  url 'http://packages.groonga.org/source/groonga/groonga-3.0.4.tar.gz'
  sha1 '51cce18d6e254629288eb83616074ffb0ec6243d'

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
