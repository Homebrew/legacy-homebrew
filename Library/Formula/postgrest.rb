require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database."
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.3.0.3.tar.gz"
  sha256 "a89eed9ed9386a701b50bdcceb3018521c2c00b7c7921c9839126f04b9c6cc6b"

  bottle do
    sha256 "74aa915078bc50f199f2368818aba331690e12fcbc090eba09957d1659f827b0" => :el_capitan
    sha256 "56b12fc875ccc6a39d8e5c2771965e1b0834221bc4fb6b9c12b3f299b8f28853" => :yosemite
    sha256 "0791ee54283991a4f794240391d3d53088777fe90cad694870d485b925d56caf" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  def install
    install_cabal_package
  end

  test do
    pg_bin  = Formula["postgresql"].bin
    pg_port = 55561
    pg_user = "postgrest_test_user"
    test_db = "test_postgrest_formula"

    system "#{pg_bin}/initdb", "-D", testpath/test_db,
      "--auth=trust", "--username=#{pg_user}"

    system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "-l",
      testpath/"#{test_db}.log", "-w", "-o", %("-p #{pg_port}"), "start"

    begin
      system "#{pg_bin}/createdb", "-w", "-p", pg_port, "-U", pg_user, test_db
      pid = fork do
        exec "postgrest", "postgres://#{pg_user}@localhost:#{pg_port}/#{test_db}",
          "-a", pg_user, "-p", "55560"
      end
      Process.detach(pid)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_equal "[]", response
    ensure
      begin
        Process.kill("TERM", pid) if pid
      ensure
        system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "stop",
          "-s", "-m", "fast"
      end
    end
  end
end
