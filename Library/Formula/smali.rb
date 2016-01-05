class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://bitbucket.org/JesusFreke/smali/downloads/smali-2.1.0.jar"
  sha256 "d6e8ad43956853a883eeb551f51635c0788ff99a682a81aa7c22cde61e8c7e8f"

  bottle do
    cellar :any_skip_relocation
    sha256 "48eefb1d2ad76ccdaed3201af6bf2db59d160df687b9f4aafcfddac90037ca71" => :el_capitan
    sha256 "8f0e302e316b2854cab3a410eb48b59039a7b19818c0f30dfa1c441a03142737" => :yosemite
    sha256 "a0cedabdb27dc89526183ecab69efd986b569ef320d77fcd5530bb3e43250779" => :mavericks
  end

  resource "baksmali-jar" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.1.0.jar"
    sha256 "7b76c6227a6f0a445f96ac7f13d885dd7a16b0ba60a3d4c6c374876947c684ce"
  end

  resource "baksmali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali"
    sha256 "5d4b79776d401f2cbdb66c7c88e23cca773b9a939520fef4bf42e2856bbbfed4"
  end

  resource "smali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/smali"
    sha256 "910297fbeefb4590e6bffd185726c878382a0960fb6a7f0733f045b6faf60a30"
  end

  def install
    resource("baksmali-jar").stage do
      libexec.install "baksmali-#{version}.jar" => "baksmali.jar"
    end
    libexec.install resource("smali"), resource("baksmali"), "smali-#{version}.jar" => "smali.jar"

    inreplace "#{libexec}/smali" do |s|
      s.gsub! /^libdir=.*$/, "libdir=\"#{libexec}\""
    end
    inreplace "#{libexec}/baksmali" do |s|
      s.gsub! /^libdir=.*$/, "libdir=\"#{libexec}\""
    end

    chmod 0755, "#{libexec}/smali"
    chmod 0755, "#{libexec}/baksmali"

    bin.install_symlink libexec/"smali"
    bin.install_symlink libexec/"baksmali"
  end

  test do
    # From examples/HelloWorld/HelloWorld.smali in Smali project repo.
    # See https://bitbucket.org/JesusFreke/smali/src/2d8cbfe6bc2d8ff2fcd7a0bf432cc808d842da4a/examples/HelloWorld/HelloWorld.smali?at=master
    (testpath/"input.smali").write <<-EOS.undent
    .class public LHelloWorld;
    .super Ljava/lang/Object;

    .method public static main([Ljava/lang/String;)V
      .registers 2
      sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
      const-string v1, "Hello World!"
      invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
      return-void
    .end method
    EOS

    system "#{bin}/smali", "-o", "classes.dex", "input.smali"
    system "#{bin}/baksmali", "-o", pwd, "classes.dex"
    assert_match "Hello World!", File.read("HelloWorld.smali")
  end
end
