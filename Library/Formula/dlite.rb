class Dlite < Formula
  desc "Provides a way to use docker on OS X without docker-machine"
  homepage "https://github.com/nlf/dlite"
  url "https://github.com/nlf/dlite/archive/1.1.4.tar.gz"
  sha256 "9fc39e4b94e141390a1f52863d4d4417f3f3c7bfd7e9622d5b8863c70f6c2c72"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d1d4f942541724222136dfc715a27935844429015767d912b49e4c7f8354690" => :el_capitan
    sha256 "b314d2118a89ceb21d37ec55fee892069348c807c5fabc33db739c0fa1a3b8a3" => :yosemite
  end

  # DLite depends on the Hypervisor framework which only works on
  # OS X versions 10.10 (Yosemite) or newer
  depends_on :macos => :yosemite
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/nlf/dlite"
    path.install Dir["*"]

    cd path do
      system "make", "dlite"
      bin.install "dlite"
    end
  end

  def caveats
    <<-EOS.undent
      Installing and upgrading dlite with brew does not automatically
      install or upgrade the dlite daemon and virtual machine.
    EOS
  end

  test do
    output = shell_output(bin/"dlite version")
    assert_match version.to_s, output
  end
end
