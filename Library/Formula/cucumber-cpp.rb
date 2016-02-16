class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/1e633c6b59c75b959b480dcc4e40123e7fc59032.tar.gz"
  version "0.3"
  sha256 "1e211db8b8c230f291c8774d1c2e2bbbcf264d92016fd6081557425e43569c19"

  depends_on "cmake" => :build
  depends_on "ruby"

  def install
    system "gem", "install", "bundler"
    system "cmake", "-DCUKE_DISABLE_GTEST=on",
                    "-DCUKE_DISABLE_CPPSPEC=on",
                    "."
    system "cmake", "--build", "."
    include.install "include/cucumber-cpp"
    lib.install Dir["src/*.a"]
  end

  test do
    system "false"
  end
end
