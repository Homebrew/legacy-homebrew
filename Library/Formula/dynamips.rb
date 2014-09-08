require 'formula'

class Dynamips < Formula
  homepage 'http://www.gns3.net/dynamips/'
  url 'https://downloads.sourceforge.net/project/gns-3/Dynamips/0.2.10/dynamips-0.2.10-source.zip'
  sha1 '6b8fc56e21db2fabfa684813b3fa56b59c6fce0a'

  depends_on 'libelf'

  def install
    ENV.append 'CFLAGS', "-I#{Formula["libelf"].include}/libelf"

    arch = Hardware.is_64_bit? ? 'amd64' : 'x86'

    ENV.j1
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "DESTDIR=#{prefix}",
                   "install"
  end
end
