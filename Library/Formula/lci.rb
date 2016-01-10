class Lci < Formula
  desc "Interpreter for the lambda calculus"
  homepage "http://lci.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lci/lci/0.6/lci-0.6.tar.gz"
  sha256 "204f1ca5e2f56247d71ab320246811c220ed511bf08c9cb7f305cf180a93948e"

  conflicts_with "lolcode", :because => "both install `lci` binaries"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
