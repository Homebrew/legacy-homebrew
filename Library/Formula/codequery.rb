require "formula"

class Codequery < Formula
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.15a.tar.gz"
  sha1 "89907121bd562b27e748c38129f40f122c538533"
  head "https://github.com/ruben2020/codequery.git"
  version "0.15a"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "qscintilla2"

  def install
    share.install "test"
    mkdir "build" do
      system "cmake", "..", "-G", "Unix Makefiles", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    cd share+"test" do
      system "#{bin}/cqmakedb", "-s", "./codequery.db", "-c", "./cscope.out", "-t", "./tags", "-p"
      assert_match "info_platform", `#{bin}/cqsearch -s ./codequery.db -t 'info_platform'`
    end
  end
end
