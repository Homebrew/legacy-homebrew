class Miruo < Formula
  desc "Pretty-print TCP session monitor/analyzer"
  homepage "https://github.com/KLab/miruo/"
  url "https://github.com/KLab/miruo/archive/0.9.6a.tar.gz"
  sha256 "346e8bd892fe15e6859486d50231238879d3b620b93df444b13a910e84864e7f"
  version "0.9.6a"

  bottle do
    cellar :any
    sha256 "740829f787698e955a9e15c78cf96cfb83b5c59035d4c70186370fb8fdacae95" => :yosemite
    sha256 "a8924a8172374a834517d5be314a14aba1135b64ad6f4ebe35fe1ff142cadfc3" => :mavericks
    sha256 "44a926fd61e8eb14e137b88161e0638bc9d55597771cc1e742764ce11a6d6c07" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    (testpath/"dummy.pcap").write("\xd4\xc3\xb2\xa1\x02\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\x00\x00\x01\x00\x00\x00")
    system "#{sbin}/miruo", "--file=dummy.pcap"
  end
end
