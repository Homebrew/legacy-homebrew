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

  depends_on :python => :optional
  depends_on 'openssl'
  depends_on 'swig' => :build if build.with? 'python'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-drill
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pyldns" if build.with? 'python'

    system "./configure", *args
    system "make"
    system "make install"
    system "make", "install-pyldns" if build.with? 'python'
    (lib/"pkgconfig").install "packaging/libldns.pc"
  end
end
