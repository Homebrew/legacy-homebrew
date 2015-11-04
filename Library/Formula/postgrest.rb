require "language/haskell"
require "net/http"

class Postgrest < Formula
  include Language::Haskell::Cabal

  desc "Serves a fully RESTful API from any existing PostgreSQL database."
  homepage "https://github.com/begriffs/postgrest"
  url "https://github.com/begriffs/postgrest/archive/v0.2.12.0.tar.gz"
  sha256 "9f7277720b947b06eb53ac0a54686eb437253d417695bc756220e703532a725a"

  bottle do
    sha256 "fc88d2190b524fde39a99855c134e5b5ed68499b5533566c097dd495f9fcfa47" => :el_capitan
    sha256 "4be5727902c6f9266aa9d885c21334db4178ba0aed72a6e227a168a3b10e8441" => :yosemite
    sha256 "aff43d1b48e1795015c03bac5467e11538e7d67ede70caa1044f2bef02245f4f" => :mavericks
  end

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
