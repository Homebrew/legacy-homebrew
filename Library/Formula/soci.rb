class Soci < Formula
  desc "Database access library for C++"
  homepage "http://soci.sourceforge.net/"
  url "http://download.sourceforge.net/project/soci/soci/soci-3.2.2/soci-3.2.2.zip"
  sha256 "e3ad3ea0ef37eab0ae9e6459d2cdd099b1fa1165b663c349e1200356cf4e9c91"

  depends_on "cmake" => :build
  depends_on "boost" => [:build, :optional]
  depends_on "sqlite" if MacOS.version <= :snow_leopard

  option "with-oracle", "Enable Oracle support."
  option "with-boost", "Enable boost support."
  option "with-mysql", "Enable MySQL support."
  option "with-odbc", "Enable ODBC support."
  option "with-pg", "Enable PostgreSQL support."

  def translate(a)
    if a == "pg" then "postgresql" else a end
  end

  fails_with :clang do
    build 421
    cause "Template oddities"
  end

  def install
    args = std_cmake_args + %w[.. -DWITH_SQLITE3:BOOL=ON]

    %w[boost mysql oracle odbc pg].each do |a|
      bool = build.with?(a) ? "ON" : "OFF"
      args << "-DWITH_#{translate(a).upcase}:BOOL=#{bool}"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end
end
