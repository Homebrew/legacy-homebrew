require "formula"

class CheckPostgres < Formula
  homepage "http://bucardo.org/wiki/Check_postgres"
  url "http://bucardo.org/downloads/check_postgres-2.21.0.tar.gz"
  sha1 "88ddb1c35a8da0feeaad90036dd27d778551a36d"

  head "https://github.com/bucardo/check_postgres.git"

  bottle do
    cellar :any
    sha1 "ff1c0bf88f5db93a9c71e583a8d9675e2db9a0dd" => :mavericks
    sha1 "5de05e3422ee2af8eb25767048a5b5e1fd4b8421" => :mountain_lion
    sha1 "d2d291e11a3720a3d0d8fce6d3409457055bee3c" => :lion
  end

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
    output = shell_output("#{bin}/check_postgres --action=connection --port=65432", 2)
    assert output.include? "POSTGRES_CONNECTION CRITICAL"
  end
end
