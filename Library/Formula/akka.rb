require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.0.2.zip'
  md5 '99e49a2246a40a1528abc2398d777bd4'

  def install
    # Remove Windows files
    rm "bin/akka.bat"

    # Translate akka script
    inreplace "bin/akka" do |s|
      s.gsub! /^declare AKKA_HOME=.*$/, "declare AKKA_HOME=#{libexec}"
    end

    system "chmod +x bin/akka"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/akka"
  end
end
