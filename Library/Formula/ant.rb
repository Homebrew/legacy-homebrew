class Ant < Formula
  desc "Java build tool"
  homepage "https://ant.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.9.6-bin.tar.bz2"
  sha256 "a43b0928960d63d6b1e2bed37e1ce4fd8fa1788ba84e08388bfe9513f02e8db3"
  head "https://git-wip-us.apache.org/repos/asf/ant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dcd44e0ed47bce38078c82531df266644c57431f07bb5a8e88f39738f3597c1a" => :el_capitan
    sha256 "4807efd018abecb583b69b87103aaf458ee456f65860e6bd6a0e01a63cace749" => :yosemite
    sha256 "d52cff7f6feb7c2c1e8c96048fc1adc103a0656c60ddbefdbc2b1da054213793" => :mavericks
    sha256 "838ffd9059831c2d0cb49c0bae1b8cbde48312042428754a476429246071e0c8" => :mountain_lion
  end

  keg_only :provided_by_osx if MacOS.version < :mavericks

  option "with-ivy", "Install ivy dependency manager"
  option "with-bcel", "Install Byte Code Engineering Library"

  resource "ivy" do
    url "https://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.4.0/apache-ivy-2.4.0-bin.tar.gz"
    sha256 "7a3d13a80b69d71608191463dfc2a74fff8ef638ce0208e70d54d28ba9785ee9"
  end

  resource "bcel" do
    url "http://central.maven.org/maven2/org/apache/bcel/bcel/5.2/bcel-5.2.jar"
    sha256 "7b87e2fd9ac3205a6e5ba9ef5e58a8f0ab8d1a0e0d00cb2a761951fa298cc733"
  end

  def install
    rm Dir["bin/*.{bat,cmd,dll,exe}"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
    rm bin/"ant"
    (bin/"ant").write <<-EOS.undent
      #!/bin/sh
      #{libexec}/bin/ant -lib #{HOMEBREW_PREFIX}/share/ant "$@"
    EOS
    if build.with? "ivy"
      resource("ivy").stage do
        (libexec/"lib").install Dir["ivy-*.jar"]
      end
    end
    if build.with? "bcel"
      resource("bcel").stage do
        (libexec/"lib").install Dir["bcel-*.jar"]
      end
    end
  end

  test do
    (testpath/"build.xml").write <<-EOS.undent
      <project name="HomebrewTest" basedir=".">
        <property name="src" location="src"/>
        <property name="build" location="build"/>
        <target name="init">
          <mkdir dir="${build}"/>
        </target>
        <target name="compile" depends="init">
          <javac srcdir="${src}" destdir="${build}"/>
        </target>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/AntTest.java").write <<-EOS.undent
      package org.homebrew;
      public class AntTest {
        public static void main(String[] args) {
          System.out.println("Testing Ant with Homebrew!");
        }
      }
    EOS
    system "#{bin}/ant", "compile"
  end
end
