require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://downloads.typesafe.com/akka/akka-2.2.3.tgz'
  sha1 '392de0a7871ce42a2eefeb6ae83cbe7a44346ecb'

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
