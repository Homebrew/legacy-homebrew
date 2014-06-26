require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://downloads.typesafe.com/akka/akka-2.3.3.tgz'
  sha256 '8eaf76e636790c5e730bb499d5d735e7a22c049c1591acb1c66f49fa417031a7'

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
