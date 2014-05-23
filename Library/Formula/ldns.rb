require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz'
  sha1 '4218897b3c002aadfc7280b3f40cda829e05c9a4'

  bottle do
    revision 2
    sha1 "0730f244c3191ccc105e681d0a046dd0a03f582d" => :mavericks
    sha1 "d1d014414e72ff7635bea795b2b140d9f33898f3" => :mountain_lion
    sha1 "1cfa7037a76eac035e4e1089514a044eff2e6b8b" => :lion
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
