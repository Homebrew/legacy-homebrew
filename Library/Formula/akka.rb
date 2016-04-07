class Akka < Formula
  desc "Toolkit for building concurrent, distributed, and fault tolerant apps"
  homepage "http://akka.io/"
  url "https://downloads.typesafe.com/akka/akka_2.11-2.4.2.zip"
  sha256 "cedd3e7c3108a25275d44459a5afb94e62b5bdfbe82505b4352b61854e00acf3"

  bottle :unneeded

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
