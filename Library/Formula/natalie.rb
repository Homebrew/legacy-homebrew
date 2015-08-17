class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.2.tar.gz"
  sha256 "a4dd246db70e8818ecde34df68a60d8bf15c51465b365f466e606f74e41714e9"
  head "https://github.com/krzyzanowskim/Natalie.git"

  bottle do
    cellar :any
    sha256 "4524f95293b7d838886370600f7350cfec1796e06bac2e67c3199f6fc73f9bb2" => :yosemite
  end

  depends_on :xcode => "6.3"

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
