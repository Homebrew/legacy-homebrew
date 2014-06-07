require "formula"

class Modman < Formula
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.9.7.tar.gz"
  sha1 "28985c511c509ea32c0633e8fd29997091c4e5f3"

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
