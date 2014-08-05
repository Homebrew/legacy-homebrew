require 'formula'

class Juise < Formula
  homepage 'https://github.com/Juniper/juise/wiki'
  url 'https://github.com/Juniper/juise/releases/download/0.6.0/juise-0.6.0.tar.gz'
  sha1 'ff2f1914619c9b216b28fdd7a82a5554ae9e1ec4'

  head do
    url 'https://github.com/Juniper/juise.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  depends_on 'libtool' => :build
  depends_on 'libslax'
  depends_on 'libssh2'
  depends_on 'pcre'
  depends_on 'sqlite'

  def install
    system "sh ./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}",
                          "--with-sqlite3-prefix=#{Formula["sqlite"].opt_prefix}",
                          "--enable-libedit"
    system "make install"
  end
end
