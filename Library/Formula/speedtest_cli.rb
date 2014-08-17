require "formula"

class SpeedtestCli < Formula
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v0.3.0.tar.gz"
  sha1 "75c402bb22484f119690f31f8a3b382cbf4ad142"

  def install
    bin.install "speedtest_cli.py" => "speedtest-cli"
    # Previous versions of the formula used "speedtest_cli"
    bin.install_symlink "speedtest-cli" => "speedtest_cli"
    man1.install "speedtest-cli.1"
  end
end
