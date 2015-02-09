class Sqlitebrowser < Formula
  homepage "http://sqlitebrowser.org"
  url "https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.5.0.tar.gz"
  sha1 "b1c351ccc0dac626ddd303a27112e0b3682fc7ee"

  head "https://github.com/sqlitebrowser/sqlitebrowser.git"

  bottle do
    cellar :any
    sha1 "b87cee7ab96ddd8892c3e4007f802ca5bf6f7045" => :yosemite
    sha1 "3ae7a4752bc3c0ba487d1096f47da72876655c7c" => :mavericks
    sha1 "b633087ab28885f058bc5bcf24ca834828d1c894" => :mountain_lion
  end

  depends_on "qt"
  depends_on "cmake" => :build
  depends_on "sqlite" => "with-functions"
  depends_on "sqlcipher" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    shell_output("#{bin}/sqlitebrowser -h")
    assert_equal 0, $?.exitstatus
  end
end
