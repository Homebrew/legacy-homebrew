class Ppss < Formula
  desc "Shell script to execute commands in parallel"
  homepage "http://ppss.googlecode.com"
  url "https://ppss.googlecode.com/files/ppss-2.97.tgz"
  sha256 "25d819a97d8ca04a27907be4bfcc3151712837ea12a671f1a3c9e58bc025360f"

  bottle :unneeded

  def install
    bin.install "ppss"
  end
end
