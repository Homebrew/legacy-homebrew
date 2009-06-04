require 'brewkit'

class PkgConfig <Formula
  @homepage='http://pkgconfig.freedesktop.org'
  @url='http://pkgconfig.freedesktop.org/releases/pkg-config-0.23.tar.gz'
  @md5='d922a88782b64441d06547632fd85744'

  #TODO depend on our glib? --with-installed-glib

  def install
    system "./configure --with-pc-path=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig:#{$root}/lib/pkgconfig --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end