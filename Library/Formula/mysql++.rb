class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "http://tangentsoft.net/mysql++/"
  url "http://tangentsoft.net/mysql++/releases/mysql++-3.2.1.tar.gz"
  sha256 "aee521873d4dbb816d15f22ee93b6aced789ce4e3ca59f7c114a79cb72f75d20"

  bottle do
    cellar :any
    sha1 "51f59174988a858aabde99fbb4bee90da14b3f05" => :yosemite
    sha1 "8efb125df0553a8c7e764c02846e258f8de73ebd" => :mavericks
    sha1 "9fedd7c2ae4b463a0ff730e29a0e493274896d2b" => :mountain_lion
  end

  depends_on "mysql-connector-c"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-field-limit=40",
                          "--with-mysql-lib=#{HOMEBREW_PREFIX}/lib",
                          "--with-mysql-include=#{HOMEBREW_PREFIX}/include"
    system "make", "install"
  end
end
