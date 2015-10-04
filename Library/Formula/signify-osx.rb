class SignifyOsx < Formula
  desc "Cryptographically sign and verify files"
  homepage "http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.2.tar.gz"
  sha256 "ac6c0cffc098abe5ad6ec444ff2d6eaf5cc61c84cbedf4f5d65766454b5f34fd"
  head "https://github.com/jpouellet/signify-osx.git"

  bottle do
    cellar :any
    sha1 "54e88a9c6e657d468dd4fcbcd0cb92e64b1c8823" => :yosemite
    sha1 "8170c1a857d715ff3cc3945f503df12affb5a9f1" => :mavericks
    sha1 "3d4cca64df2388c79b6060417be8550fbe661411" => :mountain_lion
  end

  def install
    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/signify", "-G", "-n", "-p", "pubkey", "-s", "seckey"
  end
end
