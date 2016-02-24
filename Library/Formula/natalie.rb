class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.4.tar.gz"
  sha256 "cdec277f33fcda3b5287bdc79d6f958ddfabf23fb4bf4f9e68b441173768bfde"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a87cfda63b88d60206a15c2ef27d487f38d410f268367d42728b933f91937edd" => :el_capitan
    sha256 "dbce3badcef384c4b59968545eb7bb3d7aceb9cf115cbcfe7a7d0f276c8723a0" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    mv "natalie.swift", "natalie-script.swift"
    system "xcrun", "-sdk", "macosx", "swiftc", "-O", "natalie-script.swift", "-o", "natalie.swift"
    bin.install "natalie.swift"
    share.install "NatalieExample"
  end

  test do
    example_path = "#{share}/NatalieExample"
    output_path = testpath/"Storyboards.swift"
    generated_code = `#{bin}/natalie.swift #{example_path}`
    output_path.write(generated_code)
    line_count = `wc -l #{output_path}`
    assert line_count.to_i > 1
  end
end
