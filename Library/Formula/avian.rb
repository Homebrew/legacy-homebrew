require "formula"

class Avian < Formula
  homepage "http://oss.readytalk.com/avian/"
  head "https://github.com/ReadyTalk/avian.git"
  url "https://github.com/ReadyTalk/avian/archive/v1.1.tar.gz"
  sha1 "de51fb048b0b81a131ddbb3387adb229d3eddf2f"

  depends_on :macos => :lion

  def install
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    system "make", "use-clang=true"
    bin.install Dir["build/macosx-*/avian*"]
    lib.install Dir["build/macosx-*/*.dylib", "build/macosx-*/*.a"]
  end

  test do
    (testpath/"Test.java").write <<-EOS.undent
      public class Test {
        public static void main(String arg[]) {
          System.out.print("OK");
        }
      }
    EOS
    system "javac", "Test.java"
    assert_equal "OK", shell_output("#{bin}/avian Test")
  end
end
