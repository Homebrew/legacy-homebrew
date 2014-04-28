require "formula"

class Smali < Formula
  homepage "https://bitbucket.org/JesusFreke/smali"

  url "https://bitbucket.org/JesusFreke/smali/get/v2.0.3.tar.gz"
  sha1 "b46e9589b20d62c0eae7cb2312689568d32bfc03"
  version "2.0.3"

  head "https://bitbucket.org/JesusFreke/smali.git"

  def install
    # patch the gradle.properties
    # this patch could be removed in the next release (or HEAD) of smali

    open('gradle.properties', 'a') do |f|
      f << "\nsonatypeUsername="
      f << "\nsonatypePassword="
    end

    # build

    system "./gradlew", "build"

    # install smali

    system "mv", File.readlink("smali/build/libs/smali.jar"), "smali.jar"
    libexec.install "smali.jar"

    inreplace "scripts/smali" do |s|
      s.gsub! /^libdir=.+$/, "libdir=\"#{libexec}\""
    end

    bin.install "scripts/smali"

    # install baksmali

    system "mv", File.readlink("baksmali/build/libs/baksmali.jar"), "baksmali.jar"
    libexec.install "baksmali.jar"

    inreplace "scripts/baksmali" do |s|
      s.gsub! /^libdir=.+$/, "libdir=\"#{libexec}\""
    end

    bin.install "scripts/baksmali"
  end

  test do
    # not needed because we had run unit tests while `./gradlew build`
    system "smali", "--version"
    system "baksmali", "--version"
  end
end
