require 'formula'

class Libcddb < Formula
  homepage 'http://libcddb.sourceforge.net/'
  url 'https://downloads.sourceforge.net/libcddb/libcddb-1.3.2.tar.bz2'
  sha1 '2a7855918689692ff5ca3316d078a859d51959ce'

  depends_on 'pkg-config' => :build
  depends_on 'libcdio'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
