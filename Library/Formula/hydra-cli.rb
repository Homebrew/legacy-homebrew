require "formula"

class HydraCli < Formula
  homepage "https://github.com/sdegutis/hydra-cli"
  url "https://github.com/sdegutis/hydra-cli/archive/1.0.1.tar.gz"
  sha1 "c71d8c2f5b63a99a030747eb34db49f774234acc"
  head "https://github.com/sdegutis/hydra-cli.git"

  bottle do
    cellar :any
    sha1 "d400ef1b8828aa64545e1f05c79e75de97538f4c" => :mavericks
    sha1 "faa0090500ce98fef5900d12a0def7bc2db1a040" => :mountain_lion
    sha1 "61a5f08654f8cbde7246aef2c13d278c7b094a0e" => :lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/hydra", "-h"
  end
end
