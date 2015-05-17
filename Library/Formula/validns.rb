class Validns < Formula
  homepage "http://www.validns.net/"
  url "http://www.validns.net/download/validns-0.8.tar.gz"
  sha256 "df2db0eaa998a0411ff4c1c4e417eb82d32aec4835f92f45f26c66c8d1d5bd22"

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
