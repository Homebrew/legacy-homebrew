class Gost < Formula
  homepage "https://github.com/wilhelm-murdoch/gost"
  url "https://github.com/wilhelm-murdoch/gost/archive/1.1.1.tar.gz"
  sha1 "7a1cd487203a11940491861a3b40b187fa55af56"

  depends_on "go" => :build
  depends_on :hg => :build

  def install
    ENV["GIT_DIR"] = cached_download/".git" if build.head?
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath
    system "go", "get"
    system "go", "build", "-o", "gost"
    bin.install "gost"
  end

  test do
    system bin/"gost", "--version"
  end
end
