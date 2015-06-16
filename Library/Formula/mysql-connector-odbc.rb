class MysqlConnectorOdbc < Formula
  desc "Standardized database driver"
  homepage "https://dev.mysql.com/doc/refman/5.1/en/connector-odbc.html"
  url "https://cdn.mysql.com/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.4-src.tar.gz"
  sha256 "a5f7a490f2958f2768d18b8a57f71909f9699a8619c82776b3ad1c02b8abce0d"

  bottle do
    sha256 "708cfac3af47cc8ce55f37f892050ed673536abec527154cbb0fc18e31b768e3" => :yosemite
    sha256 "eb6885b2761370b498aff49b136ed1a11b3432521f9806651c6e7d865ad24ed9" => :mavericks
    sha256 "50405191ef7e43e66a00d2977d654b75e28935030eeb7e4f3426aaa1dfc61485" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "mysql"
  depends_on "unixodbc"
  depends_on "openssl"

  option :universal

  def install
    args = std_cmake_args
    args << "-DWITH_UNIXODBC=1"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    system "cmake", ".", *args
    system "make", "install"
  end
end
