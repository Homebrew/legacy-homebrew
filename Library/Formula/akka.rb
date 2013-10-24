require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://download.akka.io/downloads/akka-2.2.0.tgz'
  sha1 '47371ef87f96b8767ff8269567fd7e2cddced9cd'

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
