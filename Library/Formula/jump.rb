require "language/go"

class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.6.1"
  sha256 "773ae036c6759d304438476c8301ed4f02270535bc2d16d860f48cd7443f4350"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "15def70b09ba153313a62ba2525f18d5ae5fb88033e6210e77c41cd4cdc28334" => :el_capitan
    sha256 "da8bc53305354af0662e2a41e2f4a36bb817ce4546727504b6381c1cfa8450d5" => :yosemite
    sha256 "39f54ae448363c7bdc756551e72b5b6e59426fb6f4ac44bcf2b6893abff7a204" => :mavericks
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
