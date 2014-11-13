require "formula"

class Dnsrend < Formula
  homepage "http://romana.now.ie/dnsrend"
  url "http://romana.now.ie/software/dnsrend-0.08.tar.gz"
  sha1 "67f97d1d00b4f371857e2e844dde4130c95cc05d"

  bottle do
    sha1 "017b703c7136f3c69c666bfc2b71e13f37c28df2" => :mavericks
    sha1 "8e973f081e71f4a036545de08ac27161398cc203" => :mountain_lion
    sha1 "0d2f73fb8de77cee8ef0fa6999aa4990adcb40d1" => :lion
  end

  resource "Net::Pcap" do
    url "http://search.cpan.org/CPAN/authors/id/S/SA/SAPER/Net-Pcap-0.17.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/S/SA/SAPER/Net-Pcap-0.17.tar.gz"
    sha1 "eca0c42bf70cf9739a0f669d37df8c4815e1c836"
  end

  resource "Net::Pcap::Reassemble" do
    url "http://search.cpan.org/CPAN/authors/id/J/JR/JRAFTERY/Net-Pcap-Reassemble-0.04.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/J/JR/JRAFTERY/Net-Pcap-Reassemble-0.04.tar.gz"
    sha1 "c6a614664e48ec21180cccdf639367c15df2481f"
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
