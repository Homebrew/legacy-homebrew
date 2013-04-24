require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.17.0/aria2-1.17.0.tar.bz2'
  sha1 'aa9d26a18e407ba1d7f9329e4f15628169a8d269'
  
  option 'with-appletls', 'Build with Secure Transport for SSL support'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'curl-ca-bundle' => :recommended

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.version == :leopard

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-bundle.crt" if build.with? 'curl-ca-bundle'
    args << "--with-appletls" if build.with? 'appletls'

    system "./configure", *args
    system "make install"
  end
end
