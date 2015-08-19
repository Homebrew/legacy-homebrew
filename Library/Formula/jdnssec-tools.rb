class JdnssecTools < Formula
  desc "Java command-line tools for DNSSEC"
  homepage "https://www.verisignlabs.com/jdnssec-tools/"
  url "https://www.verisignlabs.com/dnssec-tools/packages/jdnssec-tools-0.12.tar.gz"
  sha256 "3fa0bfe062051d9048c5186adbb04d8f5e176e50da3cdcf9b0d97e1c558efc22"

  head "https://github.com/dblacka/jdnssec-tools.git"

  bottle do
    cellar :any
    sha256 "c4a33ea5bff8ff14d8438a1dddb62da5983611d64288cd1e057b4c5419a58a87" => :yosemite
    sha256 "e5899718ae9f0b57628ecbb0bc5e6d338e7847e2a0f931992849e4c27ffc6edf" => :mavericks
    sha256 "9f87e73931c928a4b490f7a9dd858c40abde1d51f83f1c63a2212a520e8552e2" => :mountain_lion
  end

  depends_on :java

  def install
    inreplace Dir["bin/*"] do |s|
      s.gsub! /basedir=.*/, "basedir=#{libexec}"
    end
    bin.install Dir["bin/*"]
    (libexec/"lib").install Dir["lib/*"]
  end

  test do
    (testpath/"powerdns.com.key").write(
      "powerdns.com.   10773 IN  DNSKEY  257 3 8 (AwEAAb/+pXOZWYQ8mv9WM5dFva8
      WU9jcIUdDuEjldbyfnkQ/xlrJC5zA EfhYhrea3SmIPmMTDimLqbh3/4SMTNPTUF+9+U1vp
      NfIRTFadqsmuU9F ddz3JqCcYwEpWbReg6DJOeyu+9oBoIQkPxFyLtIXEPGlQzrynKubn04
      Cx83I6NfzDTraJT3jLHKeW5PVc1ifqKzHz5TXdHHTA7NkJAa0sPcZCoNE 1LpnJI/wcUpRU
      iuQhoLFeT1E432GuPuZ7y+agElGj0NnBxEgnHrhrnZW UbULpRa/il+Cr5Taj988HqX9Xdm
      6FjcP4Lbuds/44U7U8du224Q8jTrZ 57Yvj4VDQKc=)")

    assert_match /D4C3D5552B8679FAEEBC317E5F048B614B2E5F607DC57F1553182D49AB2179F7/,
      shell_output("#{bin}/jdnssec-dstool -d 2 powerdns.com.key")
  end
end
