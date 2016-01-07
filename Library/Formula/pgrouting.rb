class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.1.0.tar.gz"
  sha256 "36a6d77ed7f682ca9af79b390f5b8194bdb42e005f19a49624d369e16755f86b"
  revision 1

  bottle do
    cellar :any
    sha256 "2ca379814b706c73a156bcf31d8d82d89d4f4e1105a678bafbab53ab726cc29c" => :el_capitan
    sha256 "01857a928dc9b080fe519eb67b9fc1d333d9c84b994aa57770e333e77269f857" => :yosemite
    sha256 "df79e2e8494055dadf856332acf6d09edfc66ab7c0c40812283846233f451d7d" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

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
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION postgis;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgrouting;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
