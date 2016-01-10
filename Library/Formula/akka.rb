class Akka < Formula
  desc "Toolkit for building concurrent, distributed, and fault tolerant apps"
  homepage "http://akka.io/"
  url "https://downloads.typesafe.com/akka/akka_2.11-2.4.0.zip"
  sha256 "22155144e5828a1dc40fa0a74031d5bf10292e8fb574d1c7fc5fc0ddebd03667"

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
