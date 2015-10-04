class Classads < Formula
  desc "Classified Advertisements (used by HTCondor Central Manager)"
  homepage "http://www.cs.wisc.edu/condor/classad/"
  url "ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.10.tar.gz"
  sha256 "cde2fe23962abb6bc99d8fc5a5cbf88f87e449b63c6bca991d783afb4691efb3"

  depends_on "pcre"

  def install
    system "./configure", "--enable-namespace", "--prefix=#{prefix}"
    system "make", "install"
  end
end
