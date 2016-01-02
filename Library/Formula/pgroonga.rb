class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.1.tar.gz"
  sha256 "8bd1fa05f1a56920e2b98bd6f8e3c6631dcdd174670c7a52a2ebdeff1455ce6f"

  bottle do
    cellar :any
    sha256 "ce6b28f6eeb1a4f4a4596f86b748a02e3e5c0aa5aceaa8850bca41a76db4f41c" => :el_capitan
    sha256 "10cfe8113b1838ade1ec666d99bccb4cf2281e95f788600c31b977c787e50a83" => :yosemite
    sha256 "85331ebff8a5fdc139e56a8a95d4e16ecd4949fde58a5fe2c5d71888a2dae230" => :mavericks
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
