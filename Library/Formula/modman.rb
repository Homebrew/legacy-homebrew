require "formula"

class Modman < Formula
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.9.9.tar.gz"
  sha1 "248d68856d66941359a62db5a4a788545369c026"

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
