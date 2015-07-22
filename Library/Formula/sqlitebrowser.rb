class Sqlitebrowser < Formula
  desc "Visual tool to create, design, and edit SQLite databases"
  homepage "http://sqlitebrowser.org"
  url "https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.7.0.tar.gz"
  sha256 "3093a1dcf5b3138c1adf29857d62249ab2b068e70b001869a31151763e28cc3a"

  head "https://github.com/sqlitebrowser/sqlitebrowser.git"

  bottle do
    cellar :any
    sha256 "79e48a66a338264831c56c7354eda5d6f67c2133d05e5ca0c018db5502299f5c" => :yosemite
    sha256 "7fdd7a3c34bb74e22c120fa005a29c6bd738a2de7d4a0986c8043a1ada8857eb" => :mavericks
    sha256 "ad1ab29c1449a4deed65abaf6e6a612124fad67b13da13fbdae252fc3e72152f" => :mountain_lion
  end

  depends_on "qt"
  depends_on "cmake" => :build
  depends_on "sqlite" => "with-functions"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
