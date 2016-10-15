class TodoGo < Formula
  homepage "https://github.com/aybarscengaver/todo.go"
  url "https://github.com/aybarscengaver/todo.go/archive/0.1.0.tar.gz"
  version "1.0.0"
  sha1 "265325a89f2f15b02370d887f06f8864265321c5"
  depends_on "go"
  def install
    system "go", "build"
  end
  test do
    system false
  end
end
