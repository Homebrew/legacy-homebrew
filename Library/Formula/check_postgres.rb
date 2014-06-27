require "formula"

class CheckPostgres < Formula
  homepage "http://bucardo.org/wiki/Check_postgres"
  url "http://bucardo.org/downloads/check_postgres-2.21.0.tar.gz"
  sha1 "88ddb1c35a8da0feeaad90036dd27d778551a36d"

  head "https://github.com/bucardo/check_postgres.git"

  depends_on :postgresql

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
    mv bin/"check_postgres.pl", bin/"check_postgres"
    inreplace [bin/"check_postgres", man1/"check_postgres.1p"], "check_postgres.pl", "check_postgres"
    rm_rf prefix/"Library"
    rm_rf prefix/"lib"
  end

  test do
    # This test verifies that check_postgres fails correctly, assuming
    # that no server is running at that port.
    output = `#{bin}/check_postgres --action=connection --port=65432`
    assert output.include? "POSTGRES_CONNECTION CRITICAL"
    assert_equal 2, $?.exitstatus
  end
end
