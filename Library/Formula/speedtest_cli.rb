class SpeedtestCli < Formula
  desc "Command-line interface for http://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v0.3.2.tar.gz"
  sha256 "54e55252ffa3c10ecbd5e23b08b01a42e149db3977ac4186f6bdf16b04d79511"
  head "https://github.com/sivel/speedtest-cli.git"

  bottle :unneeded

  def install
    bin.install "speedtest_cli.py" => "speedtest-cli"
    # Previous versions of the formula used "speedtest_cli"
    bin.install_symlink "speedtest-cli" => "speedtest_cli"
    man1.install "speedtest-cli.1"
  end

  test do
    system bin/"speedtest-cli"
  end
end
