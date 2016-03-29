class Bork < Formula
  desc "Bash DSL for config management"
  homepage "https://github.com/mattly/bork"
  url "https://github.com/mattly/bork/archive/v0.10.0.tar.gz"
  sha256 "c06433ee2879b89e116a940c1549089e41e6e07da9bc1241a305bc72c14a9494"

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
