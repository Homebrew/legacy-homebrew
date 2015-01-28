HOMEBREW_PECO_VERSION="0.2.11"
class Peco < Formula
  homepage "https://github.com/peco/peco"
  if OS.mac?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_darwin_amd64.zip"
    sha1 "1c92cfa7f2dc6d85f11c4225c1b2afff506b141f"
  elsif OS.linux?
    url "https://github.com/peco/peco/releases/download/v#{HOMEBREW_PECO_VERSION}/peco_linux_amd64.tar.gz"
    sha1 "f83dc6c7334377d368cf0be43220639e3525874f"
  end

  version HOMEBREW_PECO_VERSION
  head "https://github.com/peco/peco.git", :branch => "master"

  if build.head?
    depends_on "go" => :build
    depends_on "hg" => :build
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
