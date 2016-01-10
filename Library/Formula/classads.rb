class Classads < Formula
  desc "Classified Advertisements (used by HTCondor Central Manager)"
  homepage "https://research.cs.wisc.edu/htcondor/classad/"
  url "ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.10.tar.gz"
  sha256 "cde2fe23962abb6bc99d8fc5a5cbf88f87e449b63c6bca991d783afb4691efb3"

  bottle do
    cellar :any
    sha256 "136cc9cc765d8ee3d1f1567dc1352fdecebd5971fbb34bf7fb7c1df296f72e15" => :el_capitan
    sha256 "149d6fca3c90785036075fe54d3bfb1f35a554d592dcc963628d21cc7096cfc9" => :yosemite
    sha256 "296cbe16a30b149682d56720f0cfe552c74eb9dfe08566e30be622696d26e83e" => :mavericks
  end

  depends_on "pcre"

  def install
    system "./configure", "--enable-namespace", "--prefix=#{prefix}"
    system "make", "install"
  end
end
