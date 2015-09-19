class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "http://www.pgrouting.org"
  url "https://github.com/pgRouting/pgrouting/archive/pgrouting-2.1.0.tar.gz"
  sha256 "36a6d77ed7f682ca9af79b390f5b8194bdb42e005f19a49624d369e16755f86b"

  def pour_bottle?
    # Postgres extensions must live in the Postgres prefix, which precludes
    # bottling: https://github.com/Homebrew/homebrew/issues/10247
    # Overcoming this will likely require changes in Postgres itself.
    false
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
