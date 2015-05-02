require "formula"

class Codequery < Formula
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.16.0.tar.gz"
  sha256 "4896435a8aa35dbdca43cba769aece9731f647ac9422a92c3209c2955d2e7101"

  bottle do
    cellar :any
    sha1 "a9bf2cb776cfeb79b4b13f18fcd34f9e2033545e" => :mavericks
    sha1 "736902fbf7aa648b4d06136cb02c56f968ed7aa9" => :mountain_lion
    sha1 "4d25e90e1258b94a32273424d95501ba921dc685" => :lion
  end

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
