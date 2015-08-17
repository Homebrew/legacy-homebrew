class Libev < Formula
  desc "Asynchronous event library"
  homepage "http://software.schmorp.de/pkg/libev.html"
  url "http://dist.schmorp.de/libev/Attic/libev-4.20.tar.gz"
  sha256 "f870334c7fa961e7f31087c7d76abf849f596e3048f8ed2a0aaa983cd73d449e"

  bottle do
    cellar :any
    sha256 "7943ef71a65a1a7118d314c0c428eb467e10131be82e0b3ffc3a2b179d779c3e" => :yosemite
    sha256 "21c5b5060434406af0ace8361084845422a2d28625c2388278d44eeeeecf21aa" => :mavericks
    sha256 "70631a7212920732b2dacd6155b5cdfd404c4304586203f83649c427d453a460" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end
end
