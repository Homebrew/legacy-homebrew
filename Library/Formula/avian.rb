class Avian < Formula
  desc "Lightweight VM and class library for a subset of Java features"
  homepage "http://oss.readytalk.com/avian/"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"
  head "https://github.com/ReadyTalk/avian.git"

  bottle do
    cellar :any
    sha256 "cb1db13d2ff4de8fad414bf80da2e3ccae05823f88c45322f3cdcd64da29807c" => :yosemite
    sha256 "9aadb173228eb335bd55f91bb10b1f1eed8c2722ce16fab2030c911c8fd5949f" => :mavericks
    sha256 "9810eacfe200cf6e4a85cd06d915b70363514666c7b1e24f047288be56f5c362" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on :java => "1.7+"

  def install
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
