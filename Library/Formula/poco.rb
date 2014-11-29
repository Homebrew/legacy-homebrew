require "formula"

class Poco < Formula
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.4.7/poco-1.4.7p1-all.tar.bz2"
  sha1 "29339fe4b9318d7f358f400e0847856a27ea6c4a"

  bottle do
    cellar :any
    sha1 "3deaf590ff6e90c7c9ddd70f38a39ad4e85ebafd" => :yosemite
    sha1 "e42e56f7bf77d64ce7decc089a948a04feeccceb" => :mavericks
    sha1 "270e0119505e7608d86d897cdb65f3452f9850a2" => :mountain_lion
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
