require 'formula'

class Juise < Formula
  homepage 'https://github.com/Juniper/juise/wiki'
  url 'https://github.com/Juniper/juise/releases/download/0.5.6/juise-0.5.6.tar.gz'
  sha1 '951a741f77ecb594ca745caedeed3abcfdc45a75'

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
