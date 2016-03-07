class TwitulamaCli < Formula
  desc "Show random tweet of Twit Ulama while working on console"
  homepage "https://github.com/novalagung/twitulama-cli"
  url "https://github.com/novalagung/twitulama-cli/archive/1.0.0.tar.gz"
  version "1.0.0"
  sha256 "c5d66c8dc900e6634601d3902695627c866e545eafe893ff58e0108a48ddedf5"

  def install
    bin.install "twitulama"
  end

  test do
    system "false"
  end
end
