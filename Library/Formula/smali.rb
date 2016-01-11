class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://bitbucket.org/JesusFreke/smali/downloads/smali-2.1.1.jar"
  sha256 "593f084064f8e3b77b0a211f9b94227fe31e3bfde2af558cc31382e0e3c68cc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d913e81a4da0bad0d803e40ff3e8ae2f5fc8d174b9f4ea11d76cf6ab6bdcd1" => :el_capitan
    sha256 "e1bce048795f686efcd868e8c9f120166c89d8586144cc2c3069dc8cc04d8359" => :yosemite
    sha256 "4b9b1e490a60b0a8845753c20b75432277163a1aa6fc3dd33146490dcdbce05a" => :mavericks
  end

  resource "baksmali-jar" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.1.1.jar"
    sha256 "085a84923745af8878d81f8c97b7fd046309e74c4ce97ebcdb218aaaf5256770"
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
