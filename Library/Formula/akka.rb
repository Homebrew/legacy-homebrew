require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.1.2.tgz'
  sha1 '9810331f2488df142a5f5e6e76b83d5552772aae'

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
