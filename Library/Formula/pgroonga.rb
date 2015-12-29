class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.1.tar.gz"
  sha256 "8bd1fa05f1a56920e2b98bd6f8e3c6631dcdd174670c7a52a2ebdeff1455ce6f"

  bottle do
    cellar :any
    sha256 "3eae015ffbe8d681a70f595a446d63fdeb50b5543f5369c4ea86775f7ba50c13" => :el_capitan
    sha256 "b661da8c05cca030e7012265352e0fccbe48986482ce54d2eb6d23dc137def3b" => :yosemite
    sha256 "dca08865c4a238366ddf12f782ebf7b6224a6837553074d28d6beb99703b388e" => :mavericks
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
