require 'formula'

class Avian < Formula
  homepage 'http://oss.readytalk.com/avian/'
  head 'https://github.com/ReadyTalk/avian.git'
  url 'https://github.com/ReadyTalk/avian/archive/v0.7.1.tar.gz'
  sha1 '7465b27f11de9b85f4d750e8f4f57a9b3477b87d'

  depends_on :macos => :lion

  def install
    system 'make', 'JAVA_HOME=/Library/Java/Home'
    bin.install Dir['build/darwin-*/avian*']
    lib.install Dir['build/darwin-*/*.dylib'] + Dir['build/darwin-*/*.a']
  end

  test do
    (testpath/'Test.java').write <<-EOS.undent
      public class Test {
        public static void main(String arg[]) {
          System.out.print("OK");
        }
      }
    EOS
    system 'javac', 'Test.java'
    assert_equal 'OK', `avian Test`.strip
  end
end
