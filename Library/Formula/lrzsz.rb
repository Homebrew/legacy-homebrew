class Lrzsz < Formula
  desc "Tools for zmodem/xmodem/ymodem file transfer"
  homepage "http://www.ohse.de/uwe/software/lrzsz.html"
  url "http://pkgs.fedoraproject.org/repo/pkgs/lrzsz/lrzsz-0.12.20.tar.gz/md5/b5ce6a74abc9b9eb2af94dffdfd372a4/lrzsz-0.12.20.tar.gz"
  sha256 "c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"

    # there's a bug in lrzsz when using custom --prefix
    # must install the binaries manually first
    bin.install "src/lrz", "src/lsz"

    system "make", "install"

    bin.install_symlink "lrz" => "rz", "lsz" => "sz"
  end
end
