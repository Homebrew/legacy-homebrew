class Bazel < Formula
  homepage "http://bazel.io/"
  url "https://github.com/google/bazel.git", :tag => "0.0.2"
  sha256 "5865356e74622c248248174acd09f38c07f3983867d7e687fa5932f2216e84c0"

  head "https://github.com/google/bazel.git"

  depends_on "libarchive"
  depends_on "protobuf" => :build
  depends_on :java => "1.8+"

  def install
    if build.stable?
      inreplace "compile.sh", "$(brew --prefix 2>/dev/null)/Cellar/libarchive/*/include/archive.h", "#{Formula["libarchive"].opt_include}/archive.h"
    else
      inreplace "compile.sh", "$(brew --prefix libarchive 2>/dev/null)/include/archive.h", "#{Formula["libarchive"].opt_include}/archive.h"
    end

    system "./compile.sh"
    bin.install "./output/bazel"
  end

  test do
    system "git", "clone", "https://github.com/google/bazel.git"
    system "./bootstrap_test.sh", "test"
  end
end
