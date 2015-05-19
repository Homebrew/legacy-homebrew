class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.1.tar.gz"
  sha256 "943dab1b7ac16555ec3047983a3c397f7ebe7559d3c098c02a6ee6d8e966655e"
  head "https://github.com/krzyzanowskim/Natalie.git"

  depends_on :xcode => "6.3"

  def install
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
