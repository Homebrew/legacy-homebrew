require "language/go"

class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.6.0"
  sha256 "75fb5a56747a3e26b50390eae9218851f42cf9649e18ab363810d65f78932c83"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d5b97c26acbbd81972b134069b45194f9272163757a2cf09d7209cfdc17fd53" => :el_capitan
    sha256 "9265569729daefb9f0c9b8d048524655bdef0fd6ae855df93caa10a1161325af" => :yosemite
    sha256 "9334ca6737eb0964a6329ba1a7016da04bda78384c927771e674426872070269" => :mavericks
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
