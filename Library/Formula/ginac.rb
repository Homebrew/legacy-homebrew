require 'formula'

class Ginac < Formula
  desc "GiNaC is Not a Computer algebra system"
  homepage 'http://www.ginac.de/'
  url 'http://www.ginac.de/ginac-1.6.3.tar.bz2'
  sha1 '39ebd0035491da84ca3406688c15930faebe5ef1'

  bottle do
    cellar :any
    sha1 "04f032b8d9f13b33457cf78569b71a55572fb2b8" => :yosemite
    sha1 "ecc3f94892bccb66c9f240aecc9d6d70e8fbf500" => :mavericks
    sha1 "062569680b5a725eb0316574ba2d6c22760a02e2" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'cln'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
