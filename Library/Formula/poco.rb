require "formula"

class Poco < Formula
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.4.7/poco-1.4.7p1-all.tar.bz2"
  sha1 "29339fe4b9318d7f358f400e0847856a27ea6c4a"

  bottle do
    cellar :any
    sha1 "5234c064ce6b045c647c2fe144eb4a37312cf7a1" => :yosemite
    sha1 "23c4636a3c6fc634708999981dce3a37943eb715" => :mavericks
    sha1 "cddefc836a5b38de7ad852f40f0208b95e1bb063" => :mountain_lion
  end

  devel do
    url "http://pocoproject.org/releases/poco-1.5.4/poco-1.5.4-all.tar.bz2"
    sha1 "f44b57539511bb23f6bb5387347ca08bdd9c724d"
  end

  option :cxx11

  depends_on "openssl"

  def install
    ENV.cxx11 if build.cxx11?

    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin32'
    system "./configure", "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make", "install", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
  end
end
