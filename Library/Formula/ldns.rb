require 'formula'

def build_bindings?
  ARGV.include? '--python'
end

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.13.tar.gz'
  sha1 '859f633d10b763f06b602e2113828cbbd964c7eb'

  depends_on 'swig' if build_bindings?

  def options
    [["--python", "Build Python pydns bindings"]]
  end

  def install
    # gost requires OpenSSL >= 1.0.0
    args = %W[
      --prefix=#{prefix}
      --disable-gost
      --with-drill
    ]
    args << "--with-pyldns" if build_bindings?

    system "./configure", *args
    system "make"
    system "make install"
    system "make install-pyldns" if build_bindings?
  end
end
