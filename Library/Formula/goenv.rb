require "formula"

class Goenv < Formula
  homepage "https://github.com/pwoolcoc/goenv"
  url "https://github.com/pwoolcoc/goenv/archive/1.0.tar.gz"
  sha1 "a9e2836ddc57d5b183a719168fe4cb985d509e54"
  version "1.0"

  depends_on :python

  def install
    bin.install "goenv"
  end

end
