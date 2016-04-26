class Ndiff < Formula
  desc "Virtual package provided by nmap"
  homepage "http://www.math.utah.edu/~beebe/software/ndiff/"
  url "http://ftp.math.utah.edu/pub/misc/ndiff-2.00.tar.gz"
  sha256 "f2bbd9a2c8ada7f4161b5e76ac5ebf9a2862cab099933167fe604b88f000ec2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6faf20ce4c88110019c76cc4253cd65e5743fab7cff109fc8a7d41c8f411012e" => :el_capitan
    sha256 "80adff8ec563059b7f49005c7e567b950ca58b392a4a5db18ae4957fe18b296d" => :yosemite
    sha256 "7451587f9747af6e7ffd0e5dbacd337a72cd9b7f3c45a1240c2033e0731d5d46" => :mavericks
  end

  conflicts_with "nmap", :because => "both install `ndiff` binaries"

  def install
    ENV.j1
    # Install manually as the `install` make target is crufty
    system "./configure", "--prefix=.", "--mandir=."
    mkpath "bin"
    mkpath "man/man1"
    system "make", "install"
    bin.install "bin/ndiff"
    man1.install "man/man1/ndiff.1"
  end

  test do
    system "#{bin}/ndiff", "--help"
  end
end
