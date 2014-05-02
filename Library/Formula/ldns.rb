require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz'
  sha1 '4218897b3c002aadfc7280b3f40cda829e05c9a4'

  bottle do
    revision 1
    sha1 "e7c38081f1bfef2b0cc38284bc735f7021ea415c" => :mavericks
    sha1 "6ebe8d12f028f61d06b65435741c948f3b5cdc6e" => :mountain_lion
    sha1 "99a0c73caa2ef8289e06730b39d56da5fa886cc5" => :lion
  end

  option 'with-gost', 'Compile ldns with support for GOST algorithms in DNSSEC'

  depends_on :python => :optional
  depends_on 'swig' if build.with? 'python'

  # gost requires OpenSSL >= 1.0.0
  depends_on 'openssl' if build.with? 'gost'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-drill
    ]

    if build.with? 'gost'
      args << "--with-ssl=#{HOMEBREW_PREFIX}/opt/openssl"
    else
      args << "--disable-gost"
      args << "--with-ssl=#{MacOS.sdk_path}/usr"
    end

    args << "--with-pyldns" if build.with? 'python'

    system "./configure", *args
    system "make"
    system "make install"
    system "make", "install-pyldns" if build.with? 'python'
    (lib/"pkgconfig").install "packaging/libldns.pc"
  end
end
