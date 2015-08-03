class Poco < Formula
  desc "POCO C++ Libraries"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.6.0/poco-1.6.0-all.tar.gz"
  sha256 "ed1be29ee413141269e7ccee861b11a2992a9f70072dbb28bec31ad432d71cab"

  bottle do
    cellar :any
    sha1 "32c3d4f754f5fd1b01fa2455a070f5057582a1a4" => :yosemite
    sha1 "1d844a6baf5ffa6c19697623aceb0d0035e4be38" => :mavericks
    sha1 "4f039170113a69a61657d35a2a0206743bd7f416" => :mountain_lion
  end

  option :cxx11

  depends_on "openssl"

  def install
    ENV.cxx11 if build.cxx11?

    arch = Hardware.is_64_bit? ? "Darwin64": "Darwin32"
    system "./configure", "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make", "install", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
  end
end
