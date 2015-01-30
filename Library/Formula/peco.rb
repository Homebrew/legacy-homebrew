class Peco < Formula
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/releases/download/v0.2.11/peco_darwin_amd64.zip"
  sha1 "1c92cfa7f2dc6d85f11c4225c1b2afff506b141f"
  version "0.2.11"

  head do
    url "https://github.com/peco/peco.git"
    depends_on "go" => :build
  end

  def install
    if build.head?
      ENV["GOPATH"] = buildpath
      mkdir_p buildpath/"src/github.com/peco"
      ln_s buildpath, buildpath/"src/github.com/peco/peco"
      system "go", "get", "github.com/jessevdk/go-flags"
      system "go", "get", "github.com/mattn/go-runewidth"
      system "go", "get", "github.com/nsf/termbox-go"
      system "go", "get", "github.com/peco/peco"
      system "go", "build", "cmd/peco/peco.go"
    end
    bin.install "peco"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
