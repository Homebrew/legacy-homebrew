class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.2.tar.gz"
  sha256 "1fdc4382690fb266017f38fef73d79f9f3b5c56e28f93ae93a941b4ea20e62e9"

  bottle do
    cellar :any
    sha256 "87a6c773b068904a9caba444c76711e59bfe55327019ec70a986a2d6c58678d0" => :el_capitan
    sha256 "469e0d25f823f5e0771ab74aa91dc49ee7d43bbd94e3143e701d1c02f2a8b13c" => :yosemite
    sha256 "99a8a4cb4a04ed0b815dd94b1cc3ff3d1a1fd8e83c0d125433593b63ca5cb89c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "postgresql"

  def install
    system "make"
    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2
      system "#{pg_bin}/createdb", "-p", pg_port
      system "#{pg_bin}/psql", "-p", pg_port, "--command", "CREATE DATABASE test;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgroonga;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
