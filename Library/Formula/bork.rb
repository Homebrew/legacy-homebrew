class Bork < Formula
  desc "Bash DSL for config management"
  homepage "https://github.com/mattly/bork"
  url "https://github.com/mattly/bork/archive/v0.9.1.tar.gz"
  sha256 "01ff60779582d5ec67080d43a6325d3f5f213dd3dbbbd1ba0989e0253bdc73aa"

  bottle :unneeded

  def install
    prefix.install %w[bin docs lib test types]
  end

  test do
    expected_output = "checking: directory #{testpath}/foo\r" \
                      "missing: directory #{testpath}/foo \n" \
                      "verifying : directory #{testpath}/foo\n" \
                      "* success\n"
    assert_match expected_output, shell_output("#{bin}/bork do ok directory #{testpath}/foo", 1)
  end
end
