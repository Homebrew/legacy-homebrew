require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.16.tar.gz'
  sha1 '5b4fc6c5c3078cd061905c47178478cb1015c62a'

  option "python", "Build Python pydns bindings"

  depends_on 'swig' if build.include? 'python'

  def install
    # gost requires OpenSSL >= 1.0.0
    args = %W[
      --prefix=#{prefix}
      --disable-gost
      --with-drill
    ]
    args << "--with-pyldns" if build.include? 'python'

    system "./configure", *args
    system "make"
    system "make install"
    system "make install-pyldns" if build.include? 'python'
  end
end
