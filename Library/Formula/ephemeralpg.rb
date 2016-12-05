class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "http://ephemeralpg.org"
  url "http://ephemeralpg.org/code/ephemeralpg-1.9.tar.gz"
  mirror "https://bitbucket.org/eradman/ephemeralpg/get/ephemeralpg-1.9.tar.gz"
  sha256 "3caf06f2be5d9f206f3c1174cc0c44cc359357fc7d41da026f858e01ef192792"

  depends_on :postgresql

  def install
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end

  test do
    system "#{bin}/pg_tmp", "selftest"
  end
end
