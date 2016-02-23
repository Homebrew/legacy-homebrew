class CheckPostgres < Formula
  desc "Monitor Postgres databases"
  homepage "https://bucardo.org/wiki/Check_postgres"
  url "https://bucardo.org/downloads/check_postgres-2.22.0.tar.gz"
  sha256 "29cd8ea0a0c0fcd79a1e6afb3f5a1d662c1658eef207ea89276ddb30121b85a8"

  head "https://github.com/bucardo/check_postgres.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "81c182a00790c0223551b8526a3707b278ed333b728d554426e5b4846f062e47" => :el_capitan
    sha256 "0186b2c9fc3156aeb1d4bae0bd31eb83a8a611d71fa1d4190675c453cf813c15" => :yosemite
    sha256 "2a0e2935a4e46e12ac58fd2257f2ab771a265dafe90f96a82ace5309506fe3c1" => :mavericks
    sha256 "ad3e8c1a33a93f60b7a94f24a33cea5f7a6b22dfce01df1464235380ebd5acf9" => :mountain_lion
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
    assert_match /POSTGRES_CONNECTION CRITICAL/, output
  end
end
