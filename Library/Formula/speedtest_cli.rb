class SpeedtestCli < Formula
  desc "Command-line interface for http://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v0.3.4.tar.gz"
  sha256 "e50646e245ea3c80c9653a532db0dbaef72f1c439330bcc22c381074c17b719d"
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
