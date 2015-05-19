class Dnsrend < Formula
  desc "DNS message dissector"
  homepage "http://romana.now.ie/dnsrend"
  url "http://romana.now.ie/software/dnsrend-0.08.tar.gz"
  sha256 "32fa6965f68e7090af7e4a9a06de53d12f40397f644a76cf97b6b4cb138da93a"

  bottle do
    sha1 "017b703c7136f3c69c666bfc2b71e13f37c28df2" => :mavericks
    sha1 "8e973f081e71f4a036545de08ac27161398cc203" => :mountain_lion
    sha1 "0d2f73fb8de77cee8ef0fa6999aa4990adcb40d1" => :lion
  end

  resource "Net::Pcap" do
    url "http://search.cpan.org/CPAN/authors/id/S/SA/SAPER/Net-Pcap-0.17.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/S/SA/SAPER/Net-Pcap-0.17.tar.gz"
    sha256 "aaee41ebea17924abdc2d683ec940b3e6b0dc1e5e344178395f57774746a5452"
  end

  resource "Net::Pcap::Reassemble" do
    url "http://search.cpan.org/CPAN/authors/id/J/JR/JRAFTERY/Net-Pcap-Reassemble-0.04.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/J/JR/JRAFTERY/Net-Pcap-Reassemble-0.04.tar.gz"
    sha256 "0bcba2d4134f6d412273a75663628b08b0a164e0a5ecb8a2fd14cdf5237629c4"
  end

  def install
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    libexec.install "dnsrend"
    doc.install "README"

    (bin/"dnsrend").write <<-EOS.undent
      #!/bin/sh
      /usr/bin/env perl -Tw -I "#{libexec}/lib/perl5" #{libexec}/dnsrend "$@"
    EOS
  end

  test do
    system "#{bin}/dnsrend", test_fixtures("test.pcap")
  end
end
