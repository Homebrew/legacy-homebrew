require 'formula'

class Juise < Formula
  homepage 'https://github.com/Juniper/juise/wiki'
  url 'https://github.com/Juniper/juise/archive/0.5.1.tar.gz'
  sha1 '7996f67b00d5b787d03d27258c6560f4ef3b1cf6'

  head 'https://github.com/Juniper/juise.git'

  depends_on 'automake' => :build
  depends_on 'libtool'  => :build
  depends_on 'libslax'
  depends_on 'libssh2'
  depends_on 'pcre'
  depends_on 'sqlite'

  def install
    system "sh ./bin/setup.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3-prefix=#{Formula.factory('sqlite').opt_prefix}"
    system "make install"
  end
end
