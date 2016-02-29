require "language/go"

class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://codeload.github.com/gsamokovarov/jump/tar.gz/v0.7.1"
  sha256 "ac8cb3e59079e3683f76349ca2da47ddbcc53e68950eb4713e935324ad60614d"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec225dccdd5fb23bdab942bcca183854d985ab1f86509e16bff0ea84dfb2ca9a" => :el_capitan
    sha256 "24a2f82e121ec0dd7a34c4e3721b7665bfdb116a6caaba035d30f454371fa179" => :yosemite
    sha256 "007c884a72e7677ff01762ccdebb875f9f325589445c9b46953212346579abee" => :mavericks
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
