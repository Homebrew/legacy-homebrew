require 'formula'

class Juise < Formula
  homepage 'https://github.com/Juniper/juise/wiki'
  url 'https://github.com/Juniper/juise/releases/download/0.5.7/juise-0.5.7.tar.gz'
  sha1 'b12ded68f813d128c812d7e4f381a00d21ed3291'

  head 'https://github.com/Juniper/juise.git'

  depends_on 'automake' => :build if build.head?
  depends_on 'libtool'  => :build
  depends_on 'libslax'
  depends_on 'libssh2'
  depends_on 'pcre'
  depends_on 'sqlite'

  def install
    # If build from read run script to run autoconf
    system "sh ./bin/setup.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3-prefix=#{Formula.factory('sqlite').opt_prefix}"
    system "make install"
  end
end
