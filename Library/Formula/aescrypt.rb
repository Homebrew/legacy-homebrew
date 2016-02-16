class Aescrypt < Formula
  desc "Program for encryption/decryption"
  homepage "http://aescrypt.sourceforge.net/"
  url "http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz"
  sha256 "7b17656cbbd76700d313a1c36824a197dfb776cadcbf3a748da5ee3d0791b92d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cd940c7c9e59104746a8f83f92a06e703e7f98195a202d20516c03b588fd63f" => :el_capitan
    sha256 "660c8a9266d7f85e699fb5bfabb82c508a66d303b2a2057c9c70a3c70fed43f6" => :yosemite
    sha256 "a0bf8895165037991bf5b33be5c995e9b68a1d05898003a0ef45adb7aa3d3da9" => :mavericks
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
