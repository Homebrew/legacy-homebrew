require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/releases/download/0.17.3/libslax-0.17.3.tar.gz'
  sha1 '19e72f6ab2dca12e619b9392bdc67a59eef2fbff'

  head do
    url 'https://github.com/Juniper/libslax.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  depends_on 'libtool'  => :build

  if MacOS.version <= :mountain_lion
    depends_on 'libxml2'
    depends_on 'libxslt'
  end

  depends_on 'curl' if MacOS.version <= :lion

  def install
    system "sh", "./bin/setup.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit",
                          "CFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future",
                          "CPPFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future"
    system "make install"
  end
end
