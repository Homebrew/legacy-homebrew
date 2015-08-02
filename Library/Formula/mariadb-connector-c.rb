class MariadbConnectorC < Formula
  desc "MySQL & MariaDB database connector for C/C++ applications"
  homepage "https://github.com/MariaDB/mariadb-connector-c"
  stable do
    url "https://github.com/MariaDB/mariadb-connector-c.git",
        :revision => "330b7fbdbabad44180862316d8925b302d1a8409"
    version "3.0.1"
    # Fixed libs in mariadb_config and link _libiconv_* symbols on OS X
    patch do
      url "https://github.com/MariaDB/mariadb-connector-c/commit/9e0f506.patch"
      sha256 "a4d2263d81a6064d3bb04aa2c0e7df17447a5cfeaa99b0d586e5348ee1a58b97"
    end
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on :mysql

  conflicts_with "mysql-connector-c", "mysql-connector-c++", "mysql++",
    :because => "both install MySQL client libraries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/mysql_config", "--version"
  end
end
