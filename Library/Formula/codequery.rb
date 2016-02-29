class Codequery < Formula
  desc "Index, query, or search C, C++, Java, Python, Ruby, or Go code"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.16.0.tar.gz"
  sha256 "4896435a8aa35dbdca43cba769aece9731f647ac9422a92c3209c2955d2e7101"

  bottle do
    cellar :any
    sha256 "0705afd5f032c11dec91fb317c721098f66ca5bc3193116d6a0848dd67be6b25" => :el_capitan
    sha256 "622d9750948ae1eeef67c4f2824b3af800a671bec6a358ffef3019711991796b" => :yosemite
    sha256 "ff3d941bf41fd5d9cb0947bddf3236846722a2ea6fdbb24e7f291c039a56140a" => :mavericks
    sha256 "e5e30987a1a4ca4358f2dcb6848df9cfef4d8bfce49aa72831a22cbe6125d8a6" => :mountain_lion
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
    test_files = (share/"test").children
    testpath.install_symlink test_files
    system "#{bin}/cqmakedb", "-s", "./codequery.db",
                              "-c", "./cscope.out",
                              "-t", "./tags",
                              "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
