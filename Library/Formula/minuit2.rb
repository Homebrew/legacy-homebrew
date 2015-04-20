require 'formula'

class Minuit2 < Formula
  homepage 'http://lcgapp.cern.ch/project/cls/work-packages/mathlibs/minuit/index.html'
  url 'http://www.cern.ch/mathlibs/sw/5_34_14/Minuit2/Minuit2-5.34.14.tar.gz'
  sha1 '6dc1d604f6b3adea1af72f9180d627a64ba3bc8a'

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
    system "make install"
  end
end
