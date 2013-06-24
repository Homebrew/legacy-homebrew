require 'formula'

class Libslax < Formula
  homepage 'http://www.libslax.org/'
  url 'https://github.com/Juniper/libslax/archive/0.16.2.tar.gz'
  sha1 'a2270ec7e67c540889894b732e7d4387592c7500'

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
