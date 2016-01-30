class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-2.2.2/mariadb-connector-c-2.2.2-src.tar.gz"
  sha256 "93f56ad9f08bbaf0da8ef03bc96f7093c426ae40dede60575d485e1b99e6406b"

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}
      -DWITH_OPENSSL=On
      -DCOMPILATION_COMMENT=Homebrew
    ]

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
