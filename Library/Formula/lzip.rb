class Lzip < Formula
  desc "LZMA-based compression program similar to gzip or bzip2"
  homepage "http://www.nongnu.org/lzip/lzip.html"
  url "http://download.savannah.gnu.org/releases/lzip/lzip-1.17.tar.gz"
  sha256 "9443855e0a33131233b22cdb6c62c9313a483f16cc7415efe88d4a494cea0352"

  bottle do
    cellar :any_skip_relocation
    sha256 "7914d124a70223bfa59bfcc4973810a26e6b05e99326a33efabe69b05b68df26" => :el_capitan
    sha256 "220396d58834507c1a82d6baa6713c754fd0b1363e40c6db76d6d659a6bb452a" => :yosemite
    sha256 "1a2749597e4dfee9ddc74451d932fc3d6c335ab00c1d0ca15b3b5643b696e3c6" => :mavericks
    sha256 "2932b6bfc8e63d336b58f373d46012ee379143d6e06bb9b99398149ce13edd86" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CXX=#{ENV.cxx}",
                          "CXXFLAGS=#{ENV.cflags}"
    system "make", "check"
    ENV.j1
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system "#{bin}/lzip", path
    assert !path.exist?

    # decompress: data.txt.lz -> data.txt
    system "#{bin}/lzip", "-d", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
