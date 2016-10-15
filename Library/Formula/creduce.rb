require "formula"

class Creduce < Formula
  homepage "http://embed.cs.utah.edu/creduce/"
  url "http://embed.cs.utah.edu/creduce/creduce-2.2.1.tar.gz"
  sha1 "bf1a2b9d6f55fc0d378da2cdb7a3ee1bdc8a9eaa"

  head "https://github.com/rgov/creduce.git"

  # Additional requirements flex and indent should already be available on OS X

  depends_on "astyle"
  depends_on "delta"
  depends_on "llvm" => "with-clang"

  resource "Benchmark::Timer" do
    url "http://search.cpan.org/CPAN/authors/id/D/DC/DCOPPIT/Benchmark-Timer-0.7102.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/D/DC/DCOPPIT/Benchmark-Timer-0.7102.tar.gz"
    sha1 "d977d5473b06ad12141c57ec628caa89de9181d3"
  end

  resource "Exporter::Lite" do
    url "http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/Exporter-Lite-0.06.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/N/NE/NEILB/Exporter-Lite-0.06.tar.gz"
    sha1 "efe51fb58d58d351cb067a808560c58a5611dba0"
  end

  resource "File::Which" do
    url "http://search.cpan.org/CPAN/authors/id/A/AD/ADAMK/File-Which-1.09.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/A/AD/ADAMK/File-Which-1.09.tar.gz"
    sha1 "7862595004e68276c11bc012380f19f4b09c5cf7"
  end

  resource "Getopt::Tabular" do
    url "http://search.cpan.org/CPAN/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha1 "af0e41e6fe3995f299b630118e66903c98ae285a"
  end

  resource "Regexp::Common" do
    url "http://search.cpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2013031301.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2013031301.tar.gz"
    sha1 "f8e53e84204bba33d67fd164ed18bdd75c7e932e"
  end

  resource "Sys::CPU" do
    url "http://search.cpan.org/CPAN/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    sha1 "3bca409742fd47a06768b9ba9d8f14d73171c8c1"
  end

  def llvm_prefix
    @llvm_prefix ||= Formula.factory("llvm").prefix
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-llvm=#{llvm_prefix}",
                          "--bindir=#{libexec}"
    system "make", "install"

    (bin + "creduce").write_env_script("#{libexec}/creduce", :PERL5LIB => ENV["PERL5LIB"])
  end
end
