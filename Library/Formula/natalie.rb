class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.3.tar.gz"
  sha256 "8fa28a53e963fb9bcee73b040fb6c6fbbe20d20472c8f42e0c3795603a2295f4"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "865e3241891fc71e25dd294196c3fb8a3c7a848c22009e5ba0b013197620c551" => :el_capitan
    sha256 "ba8b1886d28a9ae547b5ba1251f6e9bfc11f9d08b328e26187e49c3339ed28b7" => :yosemite
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
