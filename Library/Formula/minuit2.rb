require 'formula'

class Minuit2 < Formula
  homepage 'http://lcgapp.cern.ch/project/cls/work-packages/mathlibs/minuit/index.html'
  url 'http://www.cern.ch/mathlibs/sw/5_34_14/Minuit2/Minuit2-5.34.14.tar.gz'
  sha1 '6dc1d604f6b3adea1af72f9180d627a64ba3bc8a'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-pic",
                          "--disable-openmp",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
