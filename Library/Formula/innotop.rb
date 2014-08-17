require "formula"

class Innotop < Formula
  homepage "http://code.google.com/p/innotop/"
  url "https://innotop.googlecode.com/files/innotop-1.9.1.tar.gz"
  sha1 "6b0b5f492e7188152727f6c157043be180ba516a"

  depends_on :mysql

  resource "DBD::mysql" do
    url "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    sha1 "3bf1edd6f0b4f6144b2aaa715c80df3fb1cd2119"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
