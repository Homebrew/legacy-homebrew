require 'formula'

class Cattle < Formula
  homepage 'https://github.com/andreabolognani/cattle#readme'
  url 'https://github.com/andreabolognani/cattle/archive/cattle-1.0.1.tar.gz'
  sha1 '1c60cdf8dc6b2b27bd4dfb79adea905a22e033c2'

  depends_on 'glib'
  depends_on 'gobject-introspection'
  depends_on 'gtk-doc' => :build
  depends_on 'm4' => :build
  depends_on 'pkg-config' => :build

  def install
    ENV['LIBTOOLIZE'] = "#{HOMEBREW_PREFIX}/bin/glibtoolize"
    ENV['ACLOCAL'] = "#{HOMEBREW_PREFIX}/bin/aclocal"
    ENV['AUTOM4TE'] = "#{HOMEBREW_PREFIX}/bin/autom4te"
    ENV['AUTOMAKE'] = "#{HOMEBREW_PREFIX}/bin/automake"
    ENV['AUTOHEADER'] = "#{HOMEBREW_PREFIX}/bin/autoheader"
    ENV['AUTOCONF'] = "#{HOMEBREW_PREFIX}/bin/autoconf"

    inreplace 'autogen.sh', 'libtoolize', '$LIBTOOLIZE'
    inreplace 'autogen.sh', 'aclocal', '$ACLOCAL'
    inreplace 'autogen.sh', 'automake', '$AUTOMAKE'
    inreplace 'autogen.sh', 'autoheader', '$AUTOHEADER'
    inreplace 'autogen.sh', 'autoconf', '$AUTOCONF'

    system 'sh autogen.sh'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
