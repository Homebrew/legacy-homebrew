class Term < Formula
  url "https://raw.githubusercontent.com/liyanage/macosx-shell-scripts/e29f7eaa1eb13d78056dec85dc517626ab1d93e3/term"
  sha1 "a0df2172283facf072c82f5079243a8bc492b457"
  version "2.1"
  desc "Open terminal in specified directory (and optionally run command)"
  homepage "https://github.com/liyanage/macosx-shell-scripts/blob/master/term"

  def install
    bin.install "term"
  end
end
