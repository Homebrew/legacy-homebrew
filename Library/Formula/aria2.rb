require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.17.1/aria2-1.17.1.tar.bz2'
  sha1 'a40730013501554cdb0ce2b56a919f3ee971c06e'

  option 'with-appletls', 'Build with Secure Transport for SSL support'

  depends_on 'pkg-config' => :build
  depends_on 'gnutls'
  depends_on 'sqlite'
  depends_on 'curl-ca-bundle' => :recommended

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.version <= :leopard

  # Fixes compile error with clang 5; already upstream
  def patches
    "https://github.com/tatsuhiro-t/aria2/commit/6bcf33a69e1bfa9f7679b78f9f287d84798015aa.patch"
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-bundle.crt" if build.with? 'curl-ca-bundle'
    if build.with? 'appletls'
      args << "--with-appletls"
    else
      args << "--without-appletls"
    end

    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
