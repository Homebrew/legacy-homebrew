class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://bitbucket.org/wez/atomicparsley/overview/"
  url "https://bitbucket.org/dinkypumpkin/atomicparsley/downloads/atomicparsley-0.9.6.tar.bz2"
  sha256 "49187a5215520be4f732977657b88b2cf9203998299f238067ce38f948941562"

  bottle do
    cellar :any
    sha256 "5399733312c1c3731707421c8a0bb831a7885a0f077dc8bca87304221d748c0b" => :yosemite
    sha256 "8cc6e77f10ebf9e171354fe0a222fa205a26a1cb52b490fddd4a32aa554746f5" => :mavericks
    sha256 "faf6a14d51e5f5eb9908d038891cedb7658ccb2b1cc3af3e390c6ee10916355b" => :mountain_lion
  end

  head "https://bitbucket.org/wez/atomicparsley", :using => :hg

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make", "install"
  end
end
