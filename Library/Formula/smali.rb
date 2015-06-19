class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://code.google.com/p/smali/"
  url "https://bitbucket.org/JesusFreke/smali/downloads/smali-2.0.6.jar"
  sha256 "fcadc564a35b121361930223a4e6431e000b24b3cc992ca63dd2e35f7b28746d"

  bottle do
    cellar :any
    sha256 "84ab85c8c285d21f0086a4929829014a92a1b8e61213bb1d3c563812af7d253b" => :yosemite
    sha256 "55be916588480e0d8cb8536f3db81662ac318b20effd628369bed2186443e439" => :mavericks
    sha256 "de4a407f7e3dd02af1a00416cd8d9da813d0c268e128daf397e8854fcd4dbeec" => :mountain_lion
  end

  resource "baksmali-jar" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.0.6.jar"
    sha256 "73c62f32ff53f43a0e551959d5ef1ce4adcc900e44035063b7a360c199912652"
  end

  resource "baksmali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali"
    sha256 "c2dead21e9ed0a18494077872a4190b9928bd40983136256ab33dd96e947e409"
  end

  resource "smali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/smali"
    sha256 "7d4d9095ef54f97f49c132d33035fc1331480273e886e6e3c6fe3ffe33ce9901"
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
    assert File.read("HelloWorld.smali").include?("Hello World!")
  end
end
