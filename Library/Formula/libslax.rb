require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/releases/download/0.19.0/libslax-0.19.0.tar.gz'
  sha1 '0e55e62065012a9bd51d775a949b3d5c71957374'

  bottle do
    sha1 "975c0b0eefe8851c6f112325418ad27b95c67685" => :mavericks
    sha1 "f1c9382ca4ade67db1754c8cc956e66d6717294c" => :mountain_lion
    sha1 "b4f58c0cbedd28e51a942edad0e7ee6d01f9e640" => :lion
  end

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
                          "--enable-libedit"
    system "make install"
  end
end
