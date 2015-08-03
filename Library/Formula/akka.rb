class Akka < Formula
  desc "Toolkit for building concurrent, distributed, and fault tolerant apps"
  homepage "http://akka.io/"

  stable do
    url "https://downloads.typesafe.com/akka/akka_2.11-2.3.11.zip"
    sha256 "58157e4f85024d66e20d7e14d2681e041e385af82985eceb5210a454c251abec"
  end

  devel do
    url "https://downloads.typesafe.com/akka/akka_2.11-2.4-M2.zip"
    sha256 "dc62020928a182cfd1125bd9ec5ff4ce4fcd3629004af450653cc45ad583cfd2"
    version "2.4-M2"
  end

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    chmod 0755, "bin/akka"
    chmod 0755, "bin/akka-cluster"

    inreplace ["bin/akka", "bin/akka-cluster"] do |s|
      # Translate akka script
      s.gsub! /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}"
      # dos to unix (bug fix for version 2.3.11)
      s.gsub! /\r?/, ""
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/akka"
    bin.install_symlink libexec/"bin/akka-cluster"
  end
end
