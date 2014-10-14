require "formula"

class Ccextractor < Formula
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.73/ccextractor.src.0.73.zip"
  sha1 "bd4ffa0b90e4a80e6ce97a9f35e8e157056948b7"

  def install
    cd "mac"
    system "bash ./build.command"
    bin.install "ccextractor"
  end
end
