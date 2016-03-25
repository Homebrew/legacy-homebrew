class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.2.0.tar.gz"
  sha256 "7ec19d68cfea6babbd2fafff67df0b7c07ed27a9e80dbd01691611038442a1a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4acc59d2d7a47831e9742dde48e0d0dffc028e8f571c7e5f3fe61fe2752af4b" => :el_capitan
    sha256 "8b07aab86f0cc4fdb7407fce9ebd0e0f75cfb8be4371f9642142d713ae2d3e0c" => :yosemite
    sha256 "96d22d713a1ba5705bf573a0c14ae8a345b6a5373be489109e6370d542b9dd14" => :mavericks
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/mroth"
    ln_s buildpath, buildpath/"src/github.com/mroth/scmpuff"
    ENV["GOPATH"] = buildpath

    # scmpuff's build script normally does version detection which depends on
    # being checked out via git repo -- instead have homebrew specify version.
    system "go", "build", "-o", "#{bin}/scmpuff", "-ldflags", "-X main.VERSION=#{version}", "./src/github.com/mroth/scmpuff"
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
