class Natalie < Formula
  desc "Storyboard Code Generator (for Swift)"
  homepage "https://github.com/krzyzanowskim/Natalie"
  url "https://github.com/krzyzanowskim/Natalie/archive/0.2.tar.gz"
  sha256 "a4dd246db70e8818ecde34df68a60d8bf15c51465b365f466e606f74e41714e9"
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
