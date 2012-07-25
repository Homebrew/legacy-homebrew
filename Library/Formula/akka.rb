require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.0.2.zip'
  sha1 'b1705aaac6f9702c0c56438ed9ad572c8af2b0e8'

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
