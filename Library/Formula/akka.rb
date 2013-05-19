require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.1.3.tgz'
  sha1 '1907786c021e6806621ca93ece521ffe327ff3a3'

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
