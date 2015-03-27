class Pdf2json < Formula
  homepage "https://code.google.com/p/pdf2json/"
  url "https://pdf2json.googlecode.com/files/pdf2json-0.68.tar.gz"
  sha256 "34907954b2029a51a0b372b9db86d6c5112e4a1648201352e514ca5606050673"

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
