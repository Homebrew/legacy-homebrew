require 'formula'

class Avian < Formula
  homepage 'http://oss.readytalk.com/avian/'
  url 'http://oss.readytalk.com/avian/avian-0.6.tar.bz2'
  sha1 '763e1d99af624416aac60f0e222df938aaa3510b'

  head 'https://github.com/ReadyTalk/avian.git'

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
