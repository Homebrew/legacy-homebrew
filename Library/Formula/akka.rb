require "formula"

class Akka < Formula
  homepage "http://akka.io/"
  url "http://downloads.typesafe.com/akka/akka-2.3.5.tgz"
  sha256 "8400209225805774274334bd88c32e2e20fe8598bcec6e61bcb4b66198b2319f"

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    # Translate akka script
    inreplace "bin/akka" do |s|
      s.gsub! /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}"
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/akka"
  end
end
