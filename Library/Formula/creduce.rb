class Creduce < Formula
  homepage "https://embed.cs.utah.edu/creduce/"
  url "https://github.com/csmith-project/creduce/archive/creduce-2.2.1.tar.gz"
  sha256 "9662f4467995604d01f68250ee85a33c22ab4cd6e3cb4d7d06229aca042fce96"

  head "https://github.com/csmith-project/creduce.git"

  bottle do
    revision 1
    sha256 "3ac84a649bed07ef67515fbe88395a803524c0120779d10b71410ca1869aa847" => :yosemite
    sha256 "383bd9059854d1a143282bce412941aa459f3aa28c84d99a29921787b7c45b67" => :mavericks
  end

  depends_on "astyle"
  depends_on "delta"
  depends_on "llvm" => "with-clang"

  depends_on :macos => :mavericks

  resource "Benchmark::Timer" do
    url "http://search.cpan.org/CPAN/authors/id/D/DC/DCOPPIT/Benchmark-Timer-0.7102.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/D/DC/DCOPPIT/Benchmark-Timer-0.7102.tar.gz"
    sha256 "01446699cc7fd56cbc631d16ad73e9158a2bf63a2b045d1a1d2a3e98eaf289be"
  end

  resource "Exporter::Lite" do
    url "http://search.cpan.org/CPAN/authors/id/N/NE/NEILB/Exporter-Lite-0.06.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/N/NE/NEILB/Exporter-Lite-0.06.tar.gz"
    sha256 "f252562176c48cdc29c543d31ba3e0eed71042e9ad2b20f9f6283bd2e29e8f4c"
  end

  resource "File::Which" do
    url "http://search.cpan.org/CPAN/authors/id/A/AD/ADAMK/File-Which-1.09.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/A/AD/ADAMK/File-Which-1.09.tar.gz"
    sha256 "b72fec6590160737cba97293c094962adf4f7d44d9e68dde7062ecec13f4b2c3"
  end

  resource "Getopt::Tabular" do
    url "http://search.cpan.org/CPAN/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/G/GW/GWARD/Getopt-Tabular-0.3.tar.gz"
    sha256 "9bdf067633b5913127820f4e8035edc53d08372faace56ba6bfa00c968a25377"
  end

  resource "Regexp::Common" do
    url "http://search.cpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2013031301.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/A/AB/ABIGAIL/Regexp-Common-2013031301.tar.gz"
    sha256 "729a8198d264aa64ecbb233ff990507f97fbb66bda746b95f3286f50f5f25c84"
  end

  resource "Sys::CPU" do
    url "http://search.cpan.org/CPAN/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/M/MZ/MZSANFORD/Sys-CPU-0.61.tar.gz"
    sha256 "250a86b79c231001c4ae71d2f66428092a4fbb2070971acafd471aa49739c9e4"
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
                          "--with-llvm=#{Formula["llvm"].prefix}",
                          "--bindir=#{libexec}"
    system "make"
    system "make", "install"

    (bin+"creduce").write_env_script("#{libexec}/creduce", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    (testpath/"test1.c").write(<<-EOS.undent)
      #include <stdio.h>

      int main() {
        int i = -1;
        unsigned int j = i;
        printf("%d\n", j);
      }

    EOS
    (testpath/"test1.sh").write(<<-EOS.undent)
      #!/usr/bin/env bash

      clang -Weverything "$(dirname "${BASH_SOURCE[0]}")"/test1.c 2>&1 | \
      grep 'implicit conversion changes signedness'

    EOS

    chmod 0755, testpath/"test1.sh"
    system "#{bin}/creduce", "test1.sh", "test1.c"
  end
end
