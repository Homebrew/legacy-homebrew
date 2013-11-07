require 'formula'

class Loudmouth < Formula
  homepage 'http://mcabber.com'
  url 'http://mcabber.com/files/loudmouth-1.5.0-20121201.tar.bz2'
  version '1.5.0.20121201'
  sha1 '502963c3068f7033bb21d788918c1e5cd14f386e'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libidn'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
