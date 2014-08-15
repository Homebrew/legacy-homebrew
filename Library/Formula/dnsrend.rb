require "formula"

class Dnsrend < Formula
  homepage "http://romana.now.ie/dnsrend"
  url "http://romana.now.ie/software/dnsrend-0.08.tar.gz"
  sha1 "67f97d1d00b4f371857e2e844dde4130c95cc05d"

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
    ENV.prepend_create_path "PERL5LIB", libexec + "lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    bin.install "dnsrend"
    doc.install "README"

    perlargs = ["/usr/bin/env", "perl", "-Tw", "-I", "#{libexec}/lib/perl5"]
    system "sed", "-i", "-e", "s,#!/usr/bin/perl -Tw,#!#{perlargs.join(" ")},", "#{bin}/dnsrend"
    bin.env_script_all_files(libexec + "bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system "perl", "-c", "-Tw", "#{libexec}/bin/dnsrend"
    assert_equal 0, $?.exitstatus
  end
end
