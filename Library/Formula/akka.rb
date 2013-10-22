require 'formula'

class Akka < Formula
  homepage 'http://akka.io/'
  url 'http://downloads.typesafe.com/akka/akka-2.2.1.tgz'
  sha1 'b08d312e7978c727d206afbbcc453043ac3a481a'

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
