class Classads < Formula
  desc "Classified Advertisements (used by HTCondor Central Manager)"
  homepage "https://research.cs.wisc.edu/htcondor/classad/"
  url "http://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.10.tar.gz"
  sha256 "cde2fe23962abb6bc99d8fc5a5cbf88f87e449b63c6bca991d783afb4691efb3"

  bottle do
    cellar :any
    revision 1
    sha256 "52bd3bb21e7a2491ad96f01988b802ab183c5e93d3123e9cc57b75e1a0076171" => :el_capitan
    sha256 "2ec01b2285391e8c1a696c783db281dc69c05e0f2c483792129799b8ad304d7e" => :yosemite
    sha256 "b2ba8857a9e07ece0c19ac04a78893322bb22b361e28d5eb23abfa2515e965c9" => :mavericks
  end

  depends_on "pcre"

  def install
    system "./configure", "--enable-namespace", "--prefix=#{prefix}"
    system "make", "install"
  end
end
