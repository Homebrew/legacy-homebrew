class Muttvcardsearch < Formula
  desc "A small mutt carddav search utility for Owncloud or SOGo server"
  homepage "https://github.com/BlackIkeEagle/muttvcardsearch"
  url "https://github.com/BlackIkeEagle/muttvcardsearch/archive/v1.9.tar.gz"
  sha256 "4c099938dd02f577d8289bbc5e82f0af6f290a564a30f6fdcb5cc880cd02fc8d"

  depends_on "cmake" => :build

  # Patch required to enable CMAKE_INSTALL_PREFIX support for custom
  # installation paths.
  # Upstream pull request: https://github.com/BlackIkeEagle/muttvcardsearch/pull/10
  patch do
    url "https://patch-diff.githubusercontent.com/raw/BlackIkeEagle/muttvcardsearch/pull/10.patch"
    sha256 "683528161e1b4f19ba75c5e367917969f2d5f995fc753659d8c59079a314d3cc"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /invalid or missing arguments/, shell_output("#{bin}/muttvcardsearch", 1)
  end
end
