require 'formula'

class Classads < Formula
  homepage 'http://www.cs.wisc.edu/condor/classad/'
  url 'ftp://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.9.tar.gz'
  sha256 'f223b6d5954d3b1cd6b34dba7c7f67a69e959e350b4d9473b582895a326d3b60'

  depends_on "pcre++"

  def install
    system "./configure", "--enable-namespace", "--prefix=#{prefix}"
    system "make install"
  end
end
