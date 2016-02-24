class Pldebugger < Formula
  desc "PL/pgSQL debugger server-side code"
  homepage "http://git.postgresql.org/gitweb/"
  url "http://git.postgresql.org/git/pldebugger.git",
      :tag => "REL-9_5_0",
      :revision => "85d7b3b2821301e182d5974d9e6f353d7a241eff"
  version "1.0" # See default_version field in pldbgapi.control
  revision 1
  head "http://git.postgresql.org/git/pldebugger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d3001cc9b9f4c755d1753dcc7c94a3eaede8fb45fb14adbedee31737ca0c39" => :el_capitan
    sha256 "e58d5c816c431a633c72f20cb2499e8acf8864a86ec61f7166e95fd3ff2e5ec3" => :yosemite
    sha256 "8f0608c035891f52c8d12e26d21147b0e4ee9c97f838fd8640b3348dbfa272cb" => :mavericks
  end

  depends_on "postgresql"

  def install
    ENV["USE_PGXS"] = "1"
    pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
    system "make", "PG_CONFIG=#{pg_config}"
    mkdir "stage"
    system "make", "DESTDIR=#{buildpath}/stage", "PG_CONFIG=#{pg_config}", "install"
    lib.install Dir["stage/**/lib/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pldbgapi;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
