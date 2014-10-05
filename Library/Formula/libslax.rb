require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/releases/download/0.19.0/libslax-0.19.0.tar.gz'
  sha1 '0e55e62065012a9bd51d775a949b3d5c71957374'

  bottle do
    sha1 "2f9c5d81cf559ae7967bc664454ceec96a590659" => :mavericks
    sha1 "812a6df66e465794d817a8942dfb5bf107be19d7" => :mountain_lion
    sha1 "db00bdf5d998d64ba0a5805208866804814ccc87" => :lion
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
