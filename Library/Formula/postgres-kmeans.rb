class PostgresKmeans < Formula
  desc " K-means clustering extension for PostgreSQL"
  homepage "http://www.pgxn.org/dist/kmeans/doc/kmeans.html"
  url "http://api.pgxn.org/dist/kmeans/1.1.0/kmeans-1.1.0.zip"
  sha256 "1fafeb16e0485eb8dfbaaff83469ea593e91844832ce5e673b79ac3f5c915225"

  head "https://github.com/umitanuki/kmeans-postgresql.git"

  depends_on "postgresql"

  def install
    ENV["USE_PGXS"] = "1"
    system "make", "install"
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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION kmeans;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
