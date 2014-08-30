require "formula"

class Spiped < Formula
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.4.0.tgz"
  sha256 "d8fa13a36905337bec97e507e0689f7bbc9e5426b88d588f3ddd3d6c290dcf5f"

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
