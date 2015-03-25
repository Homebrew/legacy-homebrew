class Bazel < Formula
  homepage "http://bazel.io/"

  head "https://github.com/google/bazel.git"

  url "https://github.com/google/bazel.git", :tag => "0.0.2"
  sha256 "5865356e74622c248248174acd09f38c07f3983867d7e687fa5932f2216e84c0"

  depends_on "protobuf" => :build
  depends_on "libarchive"

  def install
    inreplace "compile.sh" do |s|
      s.gsub! "$(brew --prefix 2>/dev/null)/Cellar/libarchive/*/include/archive.h 2>/dev/null | head -n1",
              "#{Formula["libarchive"].opt_include}/archive.h | head -n1"
    end

    system "./compile.sh"

  end
end
