class SignifyOsx < Formula
  desc "Cryptographically sign and verify files"
  homepage "http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man1/signify.1"
  url "https://github.com/jpouellet/signify-osx/archive/1.2.tar.gz"
  sha256 "ac6c0cffc098abe5ad6ec444ff2d6eaf5cc61c84cbedf4f5d65766454b5f34fd"
  head "https://github.com/jpouellet/signify-osx.git"

  bottle do
    cellar :any
    sha256 "5731f0ed4d6870d29fdcd0d040ba1c011a568b97618e6e752c09fe06ad712384" => :yosemite
    sha256 "6ff9987d91649052b39b06ccf3b8aa2c70c12e31d96477d0c1542775a8304e77" => :mavericks
    sha256 "d483a3522a976b1eb3152f549028afe0b57be262c07a354d60567d62aea657c8" => :mountain_lion
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
