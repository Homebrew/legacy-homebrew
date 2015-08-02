require "formula"

class Blucat < Formula
  desc "netcat for Bluetooth"
  homepage "http://blucat.sourceforge.net/blucat/"
  url "http://blucat.sourceforge.net/blucat/wp-content/uploads/blucat-aa3e02.zip"
  sha1 "c5c801700b5d4d59f6bf0a5f0e4a405237de1840"
  version "0.9"

  depends_on "ant" => :build
  depends_on :java => "1.6"

  def install
    system "ant"
    libexec.install "blucat"
    libexec.install "lib"
    libexec.install "build"
    bin.write_exec_script libexec/"blucat"
  end

  test do
    system "#{bin}/blucat", "doctor"
  end
end
