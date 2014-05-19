require "formula"

class Rgbds < Formula
  homepage "http://anthony.bentley.name/rgbds/"
  url "https://codeload.github.com/bentley/rgbds/zip/3ecd169cd6f9d53e341efdbecb906357443b6bcf"
  sha1 "812c2f0a6a0293d78b462620cffbfbf4f2b7fbda"
  version "2014.2.21-3ecd169cd6"

  head "https://github.com/bentley/rgbds.git"

  def install
    ENV.deparallelize  # asmy.h needs to be built first
    (buildpath/"bin").mkpath
    (buildpath/"man"/"man1").mkpath
    (buildpath/"man"/"man7").mkpath
    system "make", "install", "PREFIX=#{buildpath}"
    prefix.install "bin"
    man.install "man/man1"
    man.install "man/man7"
  end

  test do
    system bin/"rgblink"
    system bin/"rgblib"
    system bin/"rgbfix"
    system bin/"rgbasm"
  end
end
