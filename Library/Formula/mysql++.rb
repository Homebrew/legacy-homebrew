class Mysqlxx < Formula
  desc "C++ wrapper for MySQL's C API"
  homepage "http://tangentsoft.net/mysql++/"
  url "http://tangentsoft.net/mysql++/releases/mysql++-3.2.1.tar.gz"
  sha256 "aee521873d4dbb816d15f22ee93b6aced789ce4e3ca59f7c114a79cb72f75d20"

  bottle do
    cellar :any
    sha256 "c08d5308c6b973026e75f2504755eeca5a348569860d215fc24e31f52e4510cd" => :yosemite
    sha256 "2b097aed1f7d0ba9bb22b521e011464daa30ce08714d5fca7445a437cda50f3a" => :mavericks
    sha256 "154e219e9cac151437d47b281ca35aa35eaf3d510b04f5e9886a0257a983a760" => :mountain_lion
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
