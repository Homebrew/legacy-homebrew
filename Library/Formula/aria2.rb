require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.16.4/aria2-1.16.4.tar.bz2'
  sha1 '302885fae5809e5bd62abd4cdb9592bb5b47c4a1'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'curl-ca-bundle' => :recommended

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.version == :leopard

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-bundle.crt" if build.with? 'curl-ca-bundle'

    system "./configure", *args
    system "make install"
  end
end
