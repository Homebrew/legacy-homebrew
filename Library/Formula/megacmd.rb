class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.012.tar.gz"
  sha256 "804861f2a7a36eef53a7310e52627e790fa9de66acf8565f697089389d2709a0"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    sha256 "a76d92587a6274e359b4bac0360b3a51f0316c4c5f6fb7ab20b22965a0d8ad8f" => :mavericks
    sha256 "9d2d5ce97263306ffd83e270a380a40e5fe1f8464830870cb132a2bdab15356c" => :mountain_lion
    sha256 "fc9d06348d244401315228598c9e3e83137fbc42e7367b08b1430ea7cb93918a" => :lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make"
    bin.install File.basename(buildpath) => "megacmd"
  end

  test do
    system "megacmd", "--version"
  end
end
