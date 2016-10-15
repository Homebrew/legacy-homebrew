class Bazel < Formula
  desc "Correct, reproducible, fast builds for everyone"
  homepage "http://bazel.io"
  url "https://github.com/bazelbuild/bazel/archive/0.1.0.tar.gz"
  sha256 "12a0fee716108fee8c0039551b9020fba3cf6c42262d304485d2788f8611ca41"

  head "https://github.com/bazelbuild/bazel.git"

  depends_on :macos => :mavericks
  depends_on :java => "1.8+"

  def install
    system "./compile.sh"
    bin.install "./output/bazel"
  end

  test do
    system "bazel"
  end
end
