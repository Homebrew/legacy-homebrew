require "formula"

class CheckPostgres < Formula
  homepage "http://bucardo.org/wiki/Check_postgres"
  url "http://bucardo.org/downloads/check_postgres-2.21.0.tar.gz"
  sha1 "88ddb1c35a8da0feeaad90036dd27d778551a36d"

  head "https://github.com/bucardo/check_postgres.git"

  option "with-tests", "run tests (requires DBD::Pg)"

  depends_on :postgresql
  # FIXME: http://librelist.com/browser/homebrew/2014/4/8/how-to-declare-a-build-time-perl-module-dependency/
  #depends_on "DBD::Pg" => [:build, :perl] if build.with? "tests"

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make"
    system "make", "test" if build.with? "tests"
    system "make", "install"
    mv bin/"check_postgres.pl", bin/"check_postgres"
    inreplace [bin/"check_postgres", man1/"check_postgres.1p"], "check_postgres.pl", "check_postgres"
    rm_rf prefix/"Library"
    rm_rf prefix/"lib"
  end

  test do
    system bin/"check_postgres", "--version"
  end
end
