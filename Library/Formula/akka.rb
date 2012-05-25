require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.0.1.zip'
  md5 '362f9c04176ed89199ae85c6d090ee71'

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
