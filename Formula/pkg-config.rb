require 'pathname'
$root=Pathname.new(__FILE__).dirname.parent
$:.unshift "#{$root}/Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://pkgconfig.freedesktop.org'
url='http://pkgconfig.freedesktop.org/releases/pkg-config-0.23.tar.gz'
md5='d922a88782b64441d06547632fd85744'

#TODO depend on our glib? --with-installed-glib

Formula.new(url, md5).brew do |prefix|
  system "./configure --with-pc-path=/usr/lib/pkgconfig:/usr/local/lib/pkgconfig:#{$root}/lib/pkgconfig --disable-debug --prefix='#{prefix}'"
  system "make install"
end