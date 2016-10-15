require "formula"

class Baksmali < Formula
  homepage "https://bitbucket.org/JesusFreke/smali"
  url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.0.3.jar"
  sha1 "39d860bc2539753c8575f39879cf8d515e1c1cb9"

  resource "exec" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali"
    sha1 "9f7a87ee158b89f9d376ba7de09e0bea39e0cad0"
  end

  def install
    libexec.install "#{name}-#{version}.jar"
    bin.install resource("exec")
    inreplace "#{bin}/#{name}" do |s|
      s.gsub! /^jarfile=.+$/, "jarfile=\"#{name}-#{version}.jar\""
      s.gsub! /^libdir=.+$/, "libdir=\"#{libexec}\""
    end
  end

end
