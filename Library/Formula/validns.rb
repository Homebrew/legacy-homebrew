class Validns < Formula
  desc "DNS/DNSSEC zone validator"
  homepage "http://www.validns.net/"
  url "http://www.validns.net/download/validns-0.8.tar.gz"
  sha256 "df2db0eaa998a0411ff4c1c4e417eb82d32aec4835f92f45f26c66c8d1d5bd22"

  bottle do
    cellar :any
    sha256 "35058db5086907db4724d357fdec06153b6c6ee682269e8d099e2e9ccf7e6bde" => :yosemite
    sha256 "b9676bbc507bd4cca40fc82ac4b4c93a939be1ad0c636372938e64dec2404000" => :mavericks
    sha256 "03136a894fe3a94f42549dac7c667ae1da171ea65491d060a7a88f4dbdb42d9d" => :mountain_lion
  end

  depends_on "judy"
  depends_on "openssl"

  def install
    system "make"
    bin.install "validns"
    man1.install "validns.1"
  end

  test do
    (testpath/"example.com").write("example.com. IN SOA ns.example.com. hostmaster.example.com. 9 10800 3600 604800 3600")
    assert_match /ttl not specified and default is not known/, shell_output("#{bin}/validns example.com 2>&1", 1)
  end
end
