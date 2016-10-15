require "formula"

class Goproj < Formula
  homepage "https://github.com/divoxx/goproj"
  url "git://github.com/divoxx/goproj.git", :revision => "d8f8cf88cb9abb3fca67117b85b18bdfcc06b823"
  version "0.1.0+git.d8f8cf88"

  def install
    bin.install "bin/goproj"
    bin.install "bin/goproj-go"
  end
end
