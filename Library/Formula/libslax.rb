require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/archive/libslax-0.16.0.tar.gz'
  sha1 'c89b46387050fe8b201f8a0f1676e504aac1b80e'

  head 'https://github.com/Juniper/libslax.git'

  depends_on 'automake' => :build
  depends_on 'libtool'  => :build

  # Need newer versions of these libraries
  if MacOS.version <= :lion
    depends_on 'libxml2'
    depends_on 'libxslt'
    depends_on 'curl'
  end

  def install
    system "sh ./bin/setup.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
