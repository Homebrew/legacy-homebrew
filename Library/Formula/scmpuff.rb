class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.1.1.tar.gz"
  sha256 "cec3c9df41acb1735f2e8c1c9840d0481af0d996690f5a19a0a8fc4f06f97370"

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/mroth"
    ln_s buildpath, buildpath/"src/github.com/mroth/scmpuff"
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
