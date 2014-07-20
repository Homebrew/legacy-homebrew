require "formula"

class Mytop < Formula
  homepage "http://jeremy.zawodny.com/mysql/mytop/"
  url "http://jeremy.zawodny.com/mysql/mytop/mytop-1.6.tar.gz"
  sha1 "e1485115ca3a15e79f7811bdc1cfe692aa95833f"

  depends_on :mysql

  resource "DBD::mysql" do
    url "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    sha1 "3bf1edd6f0b4f6144b2aaa715c80df3fb1cd2119"
  end

  patch do
    url "https://github.com/jzawodn/mytop/commit/437f2ef8d3fce02eafe935ddbf860d1dfbc43f7d.diff"
    sha1 "e0272696da8f21988f452805eeef2717ea663d43"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
