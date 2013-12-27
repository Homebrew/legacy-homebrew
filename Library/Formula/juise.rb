require 'formula'

class Juise < Formula
  homepage 'https://github.com/Juniper/juise/wiki'
  url 'https://github.com/Juniper/juise/releases/download/0.5.9/juise-0.5.9.tar.gz'
  sha1 '0d1663164904fee8ebbf29025fb2819e0ad34404'

  head do
    url 'https://github.com/Juniper/juise.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  depends_on 'libtool'  => :build
  depends_on 'libslax'
  depends_on 'libssh2'
  depends_on 'pcre'
  depends_on 'sqlite'

  def install
    system "sh ./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3-prefix=#{Formula.factory('sqlite').opt_prefix}",
                          "--enable-libedit"
    system "make install"
  end
end
