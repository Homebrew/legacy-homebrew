class EchoSd < Formula
  desc "Echo 'sudden death' message"
  homepage "https://fumiyas.github.io/2013/12/25/echo-sd.sh-advent-calendar.html"
  url "https://raw.githubusercontent.com/fumiyas/home-commands/master/echo-sd"
  sha256 "42f333ec81642f3b6a3a5fb59ab35f526dd7c86b77cdb8a420ba73eaf3846652"

  def install
    bin.install "echo-sd"
  end
end
