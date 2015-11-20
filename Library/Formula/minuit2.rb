class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "http://lcgapp.cern.ch/project/cls/work-packages/mathlibs/minuit/index.html"
  url "https://www.cern.ch/mathlibs/sw/5_34_14/Minuit2/Minuit2-5.34.14.tar.gz"
  sha256 "2ca9a283bbc315064c0a322bc4cb74c7e8fd51f9494f7856e5159d0a0aa8c356"

  bottle do
    cellar :any
    sha256 "57ecab7373c4c38a614122409d46093b2305b1faab55084ceb212022776bc6d4" => :yosemite
    sha256 "2df0da1eb93615b4ccf1f2cc6ef6eebcda6fdb8efc83743a3ffa034583dbeaa7" => :mavericks
    sha256 "847bd789ef91a039aa12eceb3fe5de9ce5bd781e3eccd34a5c56ac5f12d290d1" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--with-pic",
                          "--disable-openmp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
