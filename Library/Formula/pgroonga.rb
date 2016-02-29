class Pgroonga < Formula
  desc "PostgreSQL plugin to use Groonga as index"
  homepage "https://pgroonga.github.io/"
  url "http://packages.groonga.org/source/pgroonga/pgroonga-1.0.3.tar.gz"
  sha256 "79685f78ef6ec70e30afd5c8d7903e66332d2cf1df09177210076080098570fd"

  bottle do
    cellar :any
    sha256 "6610223aad2a906c14cb742ab2babaa12a3b415198a7e61dcfe1d955b12b36e3" => :el_capitan
    sha256 "1bc3635059d27e13f800a9f34881f057f06094a81a6717ba76a92b84b75f898d" => :yosemite
    sha256 "20a1b3427038cc3721e7596c6feb7f7c133fc1c108f8dd2499fdbdca29a1fdce" => :mavericks
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
