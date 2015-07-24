class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.3.0.tar.gz"
  sha256 "8f31508a9176b3fc843f08468b1632017f2450677bfd5147ead5136e0f24b68f"

  bottle do
    cellar :any
    sha256 "94dab837c3632f589bf4389cd1ef1a723ac5ae85259c252528e4dab3954bde74" => :yosemite
    sha256 "8b512a1d4ed2463a6bc22ddfac29efca343de35163a856c299eec396ebe031ea" => :mavericks
    sha256 "8547e62f4569969797dcbc4eba941ef8733d7e07173852364577d7d7f77e9045" => :mountain_lion
  end

  depends_on "gmp" => :optional

  def install
    args = ["PREFIX=#{prefix}"]
    args << "NTL_GMP_LIP=on" if build.with? "gmp"

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
