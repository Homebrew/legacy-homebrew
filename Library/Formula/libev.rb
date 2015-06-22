require 'formula'

class Libev < Formula
  desc "Asynchronous event library"
  homepage 'http://software.schmorp.de/pkg/libev.html'
  url 'http://dist.schmorp.de/libev/Attic/libev-4.20.tar.gz'
  sha256 'f870334c7fa961e7f31087c7d76abf849f596e3048f8ed2a0aaa983cd73d449e'

  bottle do
    cellar :any
    revision 1
    sha1 "ed65bae24001a65df1be2e2aea664af1a07b1fed" => :yosemite
    sha1 "76a348a71741db6ab9dd7420a7ede73b150bb0c9" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end
end
