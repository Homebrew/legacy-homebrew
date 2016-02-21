class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.3.tar.gz"
  version "0.3"
  sha256 "1c0f9949627e7528017bf00cbe49693ba9cbc3e11087f70aa33b21df93f341d6"

  depends_on "cmake" => :build

  def install
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
