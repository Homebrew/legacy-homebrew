class Aescrypt < Formula
  desc "Program for encryption/decryption"
  homepage "http://aescrypt.sourceforge.net/"
  url "http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz"
  sha256 "7b17656cbbd76700d313a1c36824a197dfb776cadcbf3a748da5ee3d0791b92d"

  bottle do
    cellar :any
    sha1 "0e83157b9bda1e52f645746b1e00eececffc896b" => :yosemite
    sha1 "9b17c325b41375b2635eb7a5fd729f616e73dddb" => :mavericks
    sha1 "7f8c9dbc1fe36d3a0b9fca80756a38e55c1fb1d5" => :mountain_lion
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
