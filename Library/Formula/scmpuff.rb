class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.1.1.tar.gz"
  sha256 "cec3c9df41acb1735f2e8c1c9840d0481af0d996690f5a19a0a8fc4f06f97370"

  bottle do
    cellar :any
    sha256 "f00364efe1b324301ed9ebac6cf1035d1f021fe58b0a5986d039f849a17e1965" => :yosemite
    sha256 "3cb9284bdfc2b933422f91d6777b63925c0b9835af887a321709a0170966759b" => :mavericks
    sha256 "8445d1788508e9dd7fdbb5385f7d3aec5c329f219daecefc9a25bc9bbf97e716" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/mroth"
    ln_s buildpath, buildpath/"src/github.com/mroth/scmpuff"
    ENV["GO15VENDOREXPERIMENT"] = "0"
    ENV["GOPATH"] = buildpath

    # scmpuff's build script normally does version detection which depends on
    # being checked out via git repo -- instead have homebrew specify version.
    system "go", "build", "-o", "#{bin}/scmpuff", "-ldflags", "-X main.VERSION #{version}"
  end

  test do
    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end
