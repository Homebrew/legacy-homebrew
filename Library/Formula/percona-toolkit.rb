require "formula"

class PerconaToolkit < Formula
  homepage "http://www.percona.com/software/percona-toolkit/"
  url "http://www.percona.com/redir/downloads/percona-toolkit/2.2.11/percona-toolkit-2.2.11.tar.gz"
  sha1 "7119aa553576fe52cea62944449e34a910a33e1b"

  bottle do
    sha1 "23444156b64f18978806cb5fd4e46bbab9a31760" => :yosemite
    sha1 "a19db77eaae101271cd814004ddfdd249142a0ed" => :mavericks
    sha1 "472790c8a075fbb8e7832a1ef1c72f42962d9aa3" => :mountain_lion
  end

  depends_on :mysql
  depends_on "openssl"

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
