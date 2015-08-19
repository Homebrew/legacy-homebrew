class Sqliteman < Formula
  desc "GUI tool for Sqlite3"
  homepage "http://www.sqliteman.com/"
  url "https://downloads.sourceforge.net/project/sqliteman/sqliteman/1.2.2/sqliteman-1.2.2.tar.bz2"
  sha256 "2f3281f67af464c114acd0a65f05b51672e9f5b39dd52bd2570157e8f274b10f"

  depends_on "cmake" => :build

  depends_on "qt"
  depends_on "qscintilla2"

  def install
    mkdir "build" do
      qsci_include = Formula["qscintilla2"].include
      qsci_cmake_arg = "-DQSCINTILLA_INCLUDE_DIR=#{qsci_include}/Qsci"
      system "cmake", "..", qsci_cmake_arg, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sqliteman", "--langs"
  end
end
