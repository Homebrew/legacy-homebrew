class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.5.tar.gz"
  sha256 "96e221f3da161b1b8c2c208df7ee74870718c7c71bff1c22aebad39ac29b7376"
  revision 1

  bottle do
    cellar :any
    sha256 "a04fe22315e677c8eb53e097f63ffcf1fab0610387497273195f2cfbfeb7d210" => :el_capitan
    sha256 "05e17e065b20f741da960b29e1ddb28e6f966228d97ae090eeb6546fbe62119e" => :yosemite
    sha256 "85f95652d45e452318bb7edc8d92bdf2beaa45114d54d87f7629fa78a92a5680" => :mavericks
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
