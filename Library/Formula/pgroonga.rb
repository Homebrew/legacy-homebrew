class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.2.tar.gz"
  sha256 "1fdc4382690fb266017f38fef73d79f9f3b5c56e28f93ae93a941b4ea20e62e9"

  bottle do
    cellar :any
    sha256 "20ca631e3f2c64e9477eb440a6da7352c184a15b22faa2a55a1b4d7452023149" => :el_capitan
    sha256 "18bbac7b1c535c49dba2366d41e58540a3b093c2f043c650c9c6f0a5b738e904" => :yosemite
    sha256 "efc1c2318529fb0a6d2d9ea4ddab61be11986fde641c2e2eb5e28091cc9e0612" => :mavericks
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
