require "formula"

class Akka < Formula
  homepage "http://akka.io/"
  url "https://downloads.typesafe.com/akka/akka_2.10-2.3.9.zip"
  sha256 "b790207f2bd6b8b615c08c2615f26a972580cb0391339f3c4211242adcc93d2c"

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    chmod 0755, "bin/akka"
    chmod 0755, "bin/akka-cluster"

    # Translate akka script
    inreplace "bin/akka" do |s|
      s.gsub! /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}"
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/akka"
  end
end
