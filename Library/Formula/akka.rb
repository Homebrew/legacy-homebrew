require "formula"

class Akka < Formula
  desc "Toolkit for building concurrent, distributed, and fault tolerant apps"
  homepage "http://akka.io/"
  url "https://downloads.typesafe.com/akka/akka_2.11-2.3.11.zip"
  sha256 "58157e4f85024d66e20d7e14d2681e041e385af82985eceb5210a454c251abec"

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    chmod 0755, "bin/akka"
    chmod 0755, "bin/akka-cluster"

    # dos to unix
    inreplace ["bin/akka", "bin/akka-cluster"], "\r", ""

    # Translate akka script
    inreplace ["bin/akka", "bin/akka-cluster"] do |s|
      s.gsub! /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}"
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/akka"
    bin.install_symlink libexec/"bin/akka-cluster"
  end
end
