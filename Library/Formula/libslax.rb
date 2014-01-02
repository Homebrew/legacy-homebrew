require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/releases/download/0.17.2/libslax-0.17.2.tar.gz'
  sha1 '20dba3ea27fc6dd6d9e2aa7ad6e931b1dfe8d6bc'

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
    # If build from read run script to run autoconf
    system "sh ./bin/setup.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make install"
  end
end
