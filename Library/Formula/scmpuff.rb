class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/v0.1.1.tar.gz"
  sha256 "cec3c9df41acb1735f2e8c1c9840d0481af0d996690f5a19a0a8fc4f06f97370"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "ecfcf03eeed63f84d7a785e07b0297e077792233361be3ed15b4e8e8b368f22b" => :el_capitan
    sha256 "8948b81532b1a8a3c5a97c38a82e94384314e6c0bf2d28cf3244d4092934080f" => :yosemite
    sha256 "51f096f917f9c6c36400a222f9020b80aa31f649747d048909eca7528a2c115f" => :mavericks
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
