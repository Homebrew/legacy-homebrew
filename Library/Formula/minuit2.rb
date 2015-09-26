class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "http://lcgapp.cern.ch/project/cls/work-packages/mathlibs/minuit/index.html"
  url "https://www.cern.ch/mathlibs/sw/5_34_14/Minuit2/Minuit2-5.34.14.tar.gz"
  sha256 "2ca9a283bbc315064c0a322bc4cb74c7e8fd51f9494f7856e5159d0a0aa8c356"

  bottle do
    cellar :any
    sha1 "47323eddac5d8a29c33c1fc8be03e98559b21283" => :yosemite
    sha1 "c47d5643105a8fb32c5a968a1777d6acf3fd3441" => :mavericks
    sha1 "13995bc30ba826583b695c55cccc7b9d5c31a7ef" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-pic",
                          "--disable-openmp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
