require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz'
  sha1 '4218897b3c002aadfc7280b3f40cda829e05c9a4'
  revision 1

  bottle do
    sha1 "17ad3b757668a1b6a5ecc9a3e5bed0a7d326b606" => :mavericks
    sha1 "aa5cec1eba364908b5651be159bc64ffccc4b8ad" => :mountain_lion
    sha1 "00fa56029996e5dd27eb6eb7168610dc4ce3c2cc" => :lion
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
