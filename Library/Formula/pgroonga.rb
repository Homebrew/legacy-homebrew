class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.5.tar.gz"
  sha256 "96e221f3da161b1b8c2c208df7ee74870718c7c71bff1c22aebad39ac29b7376"

  bottle do
    cellar :any
    sha256 "5765283e5702eac8a5a970ac80d309863bf82810b9e622f1004d6a49669ce3e8" => :el_capitan
    sha256 "c028b7b5fa7a65e19bcef94ac6a8f3d25fc9bbb39c8f2f2b263ccf3de3870463" => :yosemite
    sha256 "6da788f830c12c6ef58ee50cf775d5c644502576010d284fb3458138d25f464b" => :mavericks
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
