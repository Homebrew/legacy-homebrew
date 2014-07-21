require "formula"

class PerconaToolkit < Formula
  homepage "http://www.percona.com/software/percona-toolkit/"
  url "http://www.percona.com/redir/downloads/percona-toolkit/2.2.9/percona-toolkit-2.2.9.tar.gz"
  sha1 "ea0972905eedf6a1dcee4ca1a91e1f69c702127c"

  bottle do
    sha1 "7a3429a24f74a263b07805ae50ce571af8c91d9f" => :mavericks
    sha1 "07cd6fc83194fa2d355be58909a4a8f6305c44ba" => :mountain_lion
    sha1 "bd1a9e82f25683742be022bed19a611c0b669a54" => :lion
  end

  depends_on :mysql

  resource "DBD::mysql" do
    url "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    sha1 "3bf1edd6f0b4f6144b2aaa715c80df3fb1cd2119"
  end

  resource "JSON" do
    url "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    sha1 "8f0ffe72cbe9e6287d7ecafcf19b31cc297364c2"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
