class Aescrypt < Formula
  desc "Program for encryption/decryption"
  homepage "http://aescrypt.sourceforge.net/"
  url "http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz"
  sha256 "7b17656cbbd76700d313a1c36824a197dfb776cadcbf3a748da5ee3d0791b92d"

  bottle do
    cellar :any
    sha256 "50b852d15244a1efb73e3727b81c4cf28c25e50592abb9c80d169d6b64b38e4b" => :yosemite
    sha256 "8bb4d97e37f96f18b927e01fb83a9b6d0943773f641e77bebadc6ed29bcd5aef" => :mavericks
    sha256 "16bb480813e7ce113c8f2051fe5b41c0e9d78541b70c270836692176137fd4a9" => :mountain_lion
  end

  def install
    system "./configure"
    system "make"
    bin.install "aescrypt", "aesget"
  end

  test do
    (testpath/"key").write "kk=12345678901234567890123456789abc0"

    require "open3"
    Open3.popen3("#{bin}/aescrypt", "-k", testpath/"key") do |stdin, stdout, _|
      stdin.write("hello")
      stdin.close
      # we can't predict the output
      stdout.read.length > 0
    end
  end
end
