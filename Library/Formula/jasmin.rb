class Jasmin < Formula
  desc "Assembler for the Java Virtual Machine"
  homepage "http://jasmin.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/jasmin/jasmin/jasmin-2.4/jasmin-2.4.zip"
  sha256 "eaa10c68cec68206fd102e9ec7113739eccd790108a1b95a6e8c3e93f20e449d"

  bottle do
    cellar :any
    sha256 "1b95f20f08b143acb20e1aad630445c2bd231b6173a311b09641c0771f8c9d55" => :yosemite
    sha256 "b8c830842737eed6d3cd4b6004fe23696a4c71a6675204c8804b15cbed5993e2" => :mavericks
    sha256 "1b7590a56ca3e21819d03925cf57699b24518bc993af1a90e9efe4eede48cc78" => :mountain_lion
  end

  depends_on :java

  def install
    # Remove Windows scripts
    rm_rf Dir["*.bat"]

    libexec.install Dir["*.jar"]
    prefix.install %w[Readme.txt license-ant.txt license-jasmin.txt]
    bin.write_jar_script libexec/"jasmin.jar", "jasmin"
  end

  test do
    (testpath/"test.j").write <<-EOS.undent
    .class public HomebrewTest
    .super java/lang/Object

    .method public <init>()V
       aload_0
       invokespecial java/lang/Object/<init>()V
       return
    .end method

    .method public static main([Ljava/lang/String;)V
       .limit stack 2
       getstatic java/lang/System/out Ljava/io/PrintStream;
       ldc "Hello Homebrew"
       invokevirtual java/io/PrintStream/println(Ljava/lang/String;)V
       return
    .end method
    EOS
    system "#{bin}/jasmin", "#{testpath}/test.j"
    assert_equal "Hello Homebrew\n", shell_output("java HomebrewTest")
  end
end
