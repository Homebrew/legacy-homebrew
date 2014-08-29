require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.17.tar.gz'
  sha1 '4218897b3c002aadfc7280b3f40cda829e05c9a4'
  revision 1

  bottle do
    revision 3
    sha1 "29548cdff439f712695fc5ca9f662b958ce98765" => :mavericks
    sha1 "e55a981bf3a3ce87f914043c36c6c1eb0a0d9b38" => :mountain_lion
    sha1 "ba53827d4834ae71cb66c437f16e631cde014cff" => :lion
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
