class Sqlitebrowser < Formula
  desc "Visual tool to create, design, and edit SQLite databases"
  homepage "http://sqlitebrowser.org"
  url "https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.6.0.tar.gz"
  sha256 "221a410a3ec8512a766ed8bc4cade1f3b1cde94e41e52743d5a6d2a33acb3a56"

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
