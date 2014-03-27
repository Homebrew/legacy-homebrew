require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz'
  sha1 '4218897b3c002aadfc7280b3f40cda829e05c9a4'

  bottle do
    sha1 "025aea212822c6ef1a8a05bab67e7e410afe6a6b" => :mavericks
    sha1 "b9e48675dfde15036d3150b0f17c7fd1122f4f13" => :mountain_lion
    sha1 "810d64ac6ae45557d66fe9b2792344fea742fa15" => :lion
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
  end
end
