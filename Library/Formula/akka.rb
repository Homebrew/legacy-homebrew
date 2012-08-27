require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.0.3.zip'
  sha1 '073dd23724f9253085d2a9dbf1e0332fe7b7f175'

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
