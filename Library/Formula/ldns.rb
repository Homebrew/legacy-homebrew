require 'formula'

class Ldns < Formula
  homepage 'http://nlnetlabs.nl/projects/ldns/'
  url 'http://nlnetlabs.nl/downloads/ldns/ldns-1.6.16.tar.gz'
  sha1 '5b4fc6c5c3078cd061905c47178478cb1015c62a'

  depends_on :python => :optional
  depends_on 'swig' if build.with? 'python'

  def install
    # gost requires OpenSSL >= 1.0.0
    args = %W[
      --prefix=#{prefix}
      --disable-gost
      --with-drill
      --with-ssl=#{MacOS.sdk_path}/usr
    ]

    if build.with? 'python'
      args << "--with-pyldns"
      ENV['PYTHON_SITE_PKG'] = python.site_packages
    end

    system "./configure", *args
    system "make"
    system "make install"
    system "make", "install-pyldns" if build.with? 'python'
  end
end
