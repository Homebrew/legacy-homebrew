require 'formula'

class Midgard2 < Formula
  url 'https://github.com/midgardproject/midgard-core/tarball/10.05.6'
  head 'https://github.com/midgardproject/midgard-core.git', :branch => 'ratatoskr'
  homepage 'http://www.midgard-project.org/'
  md5 'df630e99f4311afe72346a72c9acbe66'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'dbus-glib'
  depends_on 'libgda'

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Package checks macros are needed for autoreconf to behave
    # correctly.
    pkg_config_path = Formula.factory("pkg-config").installed_prefix
    cp "#{pkg_config_path}/share/aclocal/pkg.m4", "m4"
    system "autoreconf", "-i", "--force"
    system "automake"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libgda4",
                          "--with-dbus-support",
                          "--enable-introspection=no"
    system "make install"
  end
end
