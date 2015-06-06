class Srtp < Formula
  desc "Implementation of the Secure Real-time Transport Protocol (SRTP)"
  homepage "https://github.com/cisco/libsrtp"
  url "https://github.com/cisco/libsrtp/archive/v1.5.2.tar.gz"
  sha256 "86e1efe353397c0751f6bdd709794143bd1b76494412860f16ff2b6d9c304eda"

  head "https://github.com/cisco/libsrtp.git"

  bottle do
    cellar :any
    sha256 "d9309ae800135653a7825673ca9f524aad5159e57f7c54d29ba1fbbb75d139f8" => :yosemite
    sha256 "3c7eff0e7a306b87513d9ced345b940ca12bb22a8b95045d932b21576d526cea" => :mavericks
    sha256 "47880688a74a1e15056b831f46addf25a80bc4ce278f5c473a2764590a040e2a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "shared_library"
    system "make", "install" # Can't go in parallel of building the dylib
  end
end
