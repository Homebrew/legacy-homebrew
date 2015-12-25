class Pldebugger < Formula
  desc "PL/pgSQL debugger server-side code"
  homepage "http://git.postgresql.org/gitweb/"
  url "http://git.postgresql.org/git/pldebugger.git",
      :tag => "REL-9_5_0",
      :revision => "85d7b3b2821301e182d5974d9e6f353d7a241eff"
  bottle do
    cellar :any_skip_relocation
    sha256 "2f2b2a88b1501f0285350d4034b02ee799bb0ca2b20f81e8063098c134504ff0" => :el_capitan
    sha256 "86a9c396d0d5e3efbf55b2071e25a0c35e0d35177d3d0c2077f686fc42dad27e" => :yosemite
    sha256 "cb047f3816d9643777ed5adedf38a68f4924ea29c0d29c2866185eb3aae5937f" => :mavericks
  end

  version "1.0" # See default_version field in pldbgapi.control
  sha256 "2bb8e27aa8f8434a4861fdbc70adb9cb4b47e1dfe472910d62d6042cb80a2ee1"

  head "http://git.postgresql.org/git/pldebugger.git"

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
