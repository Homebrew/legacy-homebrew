class Dbacl < Formula
  desc "Digramic Bayesian classifier"
  homepage "http://dbacl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dbacl/dbacl/1.14.1/dbacl-1.14.1.tar.gz"
  sha256 "ff0dfb67682e863b1c3250acc441ce77c033b9b21d8e8793e55b622e42005abd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
