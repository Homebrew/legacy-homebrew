require "formula"

class Modman < Formula
  desc "Module deployment script geared towards Magento development"
  homepage "https://github.com/colinmollenhour/modman"
  url "https://github.com/colinmollenhour/modman/archive/1.12.tar.gz"
  sha1 "8579fe1db73c606de6011f46dc38d6e1b2abecae"

  def install
    bin.install "modman"
    bash_completion.install "bash_completion" => "modman.bash"
  end

  test do
    system "#{bin}/modman"
  end
end
