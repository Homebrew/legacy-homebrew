class Sqlitebrowser < Formula
  desc "Visual tool to create, design, and edit SQLite databases"
  homepage "http://sqlitebrowser.org"
  url "https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.8.0.tar.gz"
  sha256 "f638a751bccde4bf0305a75685e2a72d26fc3e3a69d7e15fd84573f88c1a4d92"

  head "https://github.com/sqlitebrowser/sqlitebrowser.git"

  bottle do
    cellar :any
    sha256 "deca3c30ab2c07621adec645a8161afc3ffbe47efc45fd3ad1df7fa44818cda3" => :el_capitan
    sha256 "b7f615da030c8a03474c1bf1dbe4fa04608e8bcb893eb8deed9e21c325e7d338" => :yosemite
    sha256 "bdb49155b98d84480159b291c51ae01f47c0626ca56f66fc5f0d45756d36846f" => :mavericks
  end

  depends_on "qt"
  depends_on "cmake" => :build
  depends_on "sqlite" => "with-functions"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
