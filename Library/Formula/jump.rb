require "language/go"

class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.6.0"
  sha256 "75fb5a56747a3e26b50390eae9218851f42cf9649e18ab363810d65f78932c83"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce9c1818e5baa84d71596caab648b26ee03d7833dc3d727ef659a60980f2fc8b" => :el_capitan
    sha256 "85976463a23b8434e787aa5ed796b6b9d114ec7f07af619ea02f0dcd8520c62a" => :yosemite
    sha256 "ef223bce4d90130b89ec1361301b2abfe6bcbe599dae4462f54c555d0acab174" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
