require "formula"

class Probatron4j < Formula
  homepage "http://www.probatron.org"
  url "https://probatron4j.googlecode.com/files/probatron4j-0.7.4.zip"
  sha1 "0970cd2bf23eb0aab98d6537cad89bc340b877d2"

  def install
    libexec.install "probatron.jar", "notices"
    bin.write_jar_script libexec/"probatron.jar", "probatron"
  end
end
