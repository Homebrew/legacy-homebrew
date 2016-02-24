class Hub < Formula
  desc "Add GitHub support to git on the command-line"
  homepage "https://hub.github.com/"
  url "https://github.com/github/hub/archive/v2.2.3.tar.gz"
  sha256 "f8a43df60b2efd95c70054324e73f27c3b253ec1c4969de8ea6c514669c688ed"
  head "https://github.com/github/hub.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1af3676d3d03072ac50e723966c6b5e7ce0353af5dffc630e2a74a31cd66fde8" => :el_capitan
    sha256 "6c867b547061f310896fd7efdac3e48fee470c42706bc449adc3831419381951" => :yosemite
    sha256 "5b454506faf629af5e7f5f95e24e12c2badf374a07617c548c96bec4c71e45fb" => :mavericks
  end

  option "without-completions", "Disable bash/zsh completions"

  depends_on "go" => :build

  def install
    system "script/build", "-o", "hub"
    bin.install "hub"
    man1.install Dir["man/*"]

    if build.with? "completions"
      bash_completion.install "etc/hub.bash_completion.sh"
      zsh_completion.install "etc/hub.zsh_completion" => "_hub"
    end
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal "bin/brew", shell_output("#{bin}/hub ls-files -- bin").strip
    end
  end
end
