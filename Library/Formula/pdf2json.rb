class Pdf2json < Formula
  desc "PDF to JSON and XML converter"
  homepage "https://code.google.com/p/pdf2json/"
  url "https://pdf2json.googlecode.com/files/pdf2json-0.68.tar.gz"
  sha256 "34907954b2029a51a0b372b9db86d6c5112e4a1648201352e514ca5606050673"

  bottle do
    cellar :any
    sha256 "c82fefb4779c474d6a6b5eaa0e6fd6a9ccf7bd7e3962b5943367e15e6cbbdea1" => :yosemite
    sha256 "79fb8c9376d0dcc0ec6d9100912f533d9b7301ab9c6a2b90d2564701eaacaa4a" => :mavericks
    sha256 "6796505fd330e4806d40d07804532eb97b9d4cdb8c0a1d270727b9181b4b7ab9" => :mountain_lion
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "src/pdf2json"
  end

  test do
    system bin/"pdf2json", test_fixtures("test.pdf"), "test.json"
    assert File.exist?("test.json")
  end
end
