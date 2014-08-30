require "formula"

class Spiped < Formula
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.4.0.tgz"
  sha256 "d8fa13a36905337bec97e507e0689f7bbc9e5426b88d588f3ddd3d6c290dcf5f"

  bottle do
    cellar :any
    sha1 "a5c02e5820d9e0257c8f7989e411f225bd7059bd" => :mavericks
    sha1 "bf7b0a89918b04698a793bf503c202a4ef6a883e" => :mountain_lion
    sha1 "36d6b9cbf1d2128321a60ec487fb6f984347502f" => :lion
  end

  depends_on :bsdmake
  depends_on "openssl"

  def install
    # Apply these minor build fixes until they are committed upstream; see
    # http://mail.tarsnap.com/spiped/msg00098.html .
    inreplace "POSIX/posix-cflags.sh", /echo "-D(.*)"/, "printf %s \"-D\\1 \""
    inreplace "Makefile", " make", " ${MAKE}"

    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
    doc.install "spiped/README" => "README.spiped",
                "spipe/README" => "README.spipe"
  end
end
