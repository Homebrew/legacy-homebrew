class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "http://lcgapp.cern.ch/project/cls/work-packages/mathlibs/minuit/index.html"
  url "https://www.cern.ch/mathlibs/sw/5_34_14/Minuit2/Minuit2-5.34.14.tar.gz"
  sha256 "2ca9a283bbc315064c0a322bc4cb74c7e8fd51f9494f7856e5159d0a0aa8c356"

  bottle do
    cellar :any
    revision 1
    sha256 "7457852262758583daca3f23ac3e6fa312fe0a3fd84f0b20da2081967124a0fc" => :el_capitan
    sha256 "32ff2d05e0a85b28513789e1f625e654f2141b80202f506ad0f7721caab95ddd" => :yosemite
    sha256 "e2b2aba706d32238723ee7aaba7e4c536d68a6979b01c67e944bb34039653f40" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-pic",
                          "--disable-openmp",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
