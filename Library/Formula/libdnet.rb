require 'formula'

class Libdnet < Formula
  url 'http://libdnet.googlecode.com/files/libdnet-1.12.tgz'
  homepage 'http://code.google.com/p/libdnet/'
  md5 '9253ef6de1b5e28e9c9a62b882e44cc9'

  def install
    # "manual" autoreconf to get '.dylib' extension on shared lib
    system "aclocal --force -I config"
    system "glibtoolize --copy --force"
    system "autoconf --force"
    system "autoheader --force"
    system "automake --add-missing --copy --force-missing"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
