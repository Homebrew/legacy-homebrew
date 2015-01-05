require "formula"

class Modman < Formula
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.10.tar.gz"
  sha1 "6469426438d4f932f6863d6e2669a264b254944d"

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
