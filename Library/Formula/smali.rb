require "formula"

class Smali < Formula
  homepage "http://smali.googlecode.com/"
  url "https://bitbucket.org/JesusFreke/smali/downloads/smali-2.0.3.jar", :using => :nounzip
  sha1 "42774f5d949add1739299785feb83f3dec32f240"

  bottle do
    cellar :any
    sha1 "042f4692b35ab5d483aa291e3a4924565fe1510f" => :yosemite
    sha1 "a9e5893ba2cc5bdd4b0b1e9ab489cf8863a48dfb" => :mavericks
    sha1 "f6829e47d12e951c4ea37784496bed1b79cebf0d" => :mountain_lion
  end

  resource "baksmali-jar" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.0.3.jar", :using => :nounzip
    sha1 "39d860bc2539753c8575f39879cf8d515e1c1cb9"
  end

  resource "baksmali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali", :using => :nounzip
    sha1 "9f7a87ee158b89f9d376ba7de09e0bea39e0cad0"
  end

  resource "smali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/smali", :using => :nounzip
    sha1 "26423d6a1d882d3feac0fd0b93ddae0ab134551f"
  end

  def install
    resource("baksmali-jar").stage {
      libexec.install "baksmali-2.0.3.jar" => "baksmali.jar"
    }
    libexec.install resource("smali"), resource("baksmali"), "smali-2.0.3.jar" => "smali.jar"

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
