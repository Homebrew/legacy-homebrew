# makemake formula

class Makemake < Formula

  homepage "https://github.com/Julow/makemake"

  url "https://github.com/Julow/makemake.git", :revision => "a11bba0903aad98765b7fdac0a67ed09903ba669"
  head "https://github.com/Julow/makemake.git"
  # :using => :git is "Redundant"

  sha256 "47b79f953e39db26d4cdd612572c52e9a06b7899025ef53ed874baa4a7a03b23"
  version "1.0"

  def install

    mv "makemake.py", "makemake"
    bin.install "makemake"

  end

  test do

    system "echo", "Makemake is an interative program"
    system "makemake", "-h"

  end
end
