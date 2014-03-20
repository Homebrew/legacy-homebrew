require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz'
  sha1 '4218897b3c002aadfc7280b3f40cda829e05c9a4'

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
  end
end
