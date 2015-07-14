class Ppss < Formula
  desc "Shell script to execute commands in parallel"
  homepage "https://github.com/louwrentius/PPSS"
  url "https://ppss.googlecode.com/files/ppss-2.97.tgz"
  sha256 "25d819a97d8ca04a27907be4bfcc3151712837ea12a671f1a3c9e58bc025360f"

  head "https://github.com/louwrentius/PPSS.git"

  def install
    bin.install "ppss"
  end
end
