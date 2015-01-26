require "formula"

class Poco < Formula
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.6.0/poco-1.6.0-all.tar.gz"
  sha1 "b45486757bfc132631d31724342a62cf41dc2795"

  bottle do
    cellar :any
    sha1 "3deaf590ff6e90c7c9ddd70f38a39ad4e85ebafd" => :yosemite
    sha1 "e42e56f7bf77d64ce7decc089a948a04feeccceb" => :mavericks
    sha1 "270e0119505e7608d86d897cdb65f3452f9850a2" => :mountain_lion
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
