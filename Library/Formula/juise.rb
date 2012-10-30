require 'formula'

class Juise < Formula
  homepage 'http://code.google.com/p/juise/'
  url 'http://juise.googlecode.com/files/juise-0.3.15.tar.gz'
  sha1 '9ec4ea9a078b7e5a4c72efe241b7089683fe50f1'

  depends_on 'libtool'  => :build
  depends_on 'libslax'
  depends_on 'libssh2'
  depends_on 'pcre'

  # Need newer versions of these libraries
  if MacOS.version <= :lion
    depends_on 'libxml2'
    depends_on 'libxslt'
    depends_on 'curl'
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libssh2-prefix=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
