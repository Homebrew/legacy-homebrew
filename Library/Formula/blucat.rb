require "formula"

class Blucat < Formula
  homepage "http://blucat.sourceforge.net/blucat/"
  url "http://blucat.sourceforge.net/blucat/wp-content/uploads/2013/10/blucat-aa3e02.zip"
  sha1 "c5c801700b5d4d59f6bf0a5f0e4a405237de1840"

  depends_on "ant" => :build

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
