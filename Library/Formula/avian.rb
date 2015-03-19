class Avian < Formula
  homepage "http://oss.readytalk.com/avian/"
  head "https://github.com/ReadyTalk/avian.git"
  url "https://github.com/ReadyTalk/avian/archive/v1.2.0.tar.gz"
  sha256 "e3639282962239ce09e4f79f327c679506d165810f08c92ce23e53e86e1d621c"

  bottle do
    cellar :any
    sha1 "ec4bf9872744d3afd83131dd585b525fce19f898" => :yosemite
    sha1 "3c8e3d20400aad2f5c5dc60f6b6b4ae3094eef6b" => :mavericks
    sha1 "dfb49aaec4a22570127f72f503712aa4475e1742" => :mountain_lion
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
