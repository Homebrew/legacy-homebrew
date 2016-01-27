class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.6.3.tar.gz"
  sha256 "59d59872ec5f3f0848aa0766aa46ead6ac041be73899f6e9b8d6a18af41f8136"

  bottle do
    cellar :any_skip_relocation
    sha256 "55a64d1bd9ae612707e1a91d00099246d670296421d6e22fb926046e1bc0b0f7" => :el_capitan
    sha256 "223b2f97a78cea6fa2c85728159058b83943c75aea30c7c7a289b49c90579919" => :yosemite
    sha256 "b229f7cf772ec9ab10fd4abb641e914b3477848dc6be8e762d8ef8757367943b" => :mavericks
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
