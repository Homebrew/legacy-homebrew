class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.2.0.tar.gz"
  sha256 "2bca70534b133904dd814a1d2a111f787a7506fa6f08f2e7f3fc9288b3bfd101"

  depends_on "gmp" => :optional

  bottle do
    cellar :any
    sha256 "94dab837c3632f589bf4389cd1ef1a723ac5ae85259c252528e4dab3954bde74" => :yosemite
    sha256 "8b512a1d4ed2463a6bc22ddfac29efca343de35163a856c299eec396ebe031ea" => :mavericks
    sha256 "8547e62f4569969797dcbc4eba941ef8733d7e07173852364577d7d7f77e9045" => :mountain_lion
  end

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
