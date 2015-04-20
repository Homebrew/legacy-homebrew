require "formula"

class Modman < Formula
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.11.tar.gz"
  sha1 "7b9d2f271eed83135c228e4f9de19f0134acfa1c"

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
