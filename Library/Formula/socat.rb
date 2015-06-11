class Socat < Formula
  desc "netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.3.0.tar.gz"
  sha256 "f8de4a2aaadb406a2e475d18cf3b9f29e322d4e5803d8106716a01fd4e64b186"

  bottle do
    cellar :any
    sha1 "1dbd28a373b01b68aa18882f27a4ad82a75cdcd6" => :yosemite
    sha1 "af4f37fa4ac0083200f6ede2e740a35b69decc0e" => :mavericks
    sha1 "1e756f77d2956ceea9ea454d62ef1ae58e90d1ad" => :mountain_lion
  end

  devel do
    url "http://www.dest-unreach.org/socat/download/socat-2.0.0-b8.tar.bz2"
    sha256 "c804579db998fb697431c82829ae03e6a50f342bd41b8810332a5d0661d893ea"
    version "2.0.0-b8"
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/socat -V")
  end
end
