require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database."
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.2.12.0.tar.gz"
  sha256 "9f7277720b947b06eb53ac0a54686eb437253d417695bc756220e703532a725a"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "postgresql"

  setup_ghc_compilers

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
      pid = Process.spawn("postgrest -d #{test_db} -P #{pg_port} " \
                          "-U #{pg_user} -a #{pg_user} -p 55560",
                          :out => "/dev/null", :err => "/dev/null",)
      sleep(5) # Wait for the server to start
      response = Net::HTTP.get(URI("http://localhost:55560"))
      assert_equal "[]", response
    ensure
      Process.kill("TERM", pid) if pid
      system "#{pg_bin}/pg_ctl", "-D", testpath/test_db, "stop",
        "-s", "-m", "fast"
    end
  end
end
