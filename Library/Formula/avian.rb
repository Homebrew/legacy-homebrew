require 'formula'

class LionOrNewer < Requirement
  fatal true

  satisfy MacOS.version >= :lion

  def message
    "Avian requires Mac OS X 10.7 (Lion) or newer."
  end
end

class JdkInstalled < Requirement
  fatal true

  satisfy { which 'javac' }

  def message; <<-EOS.undent
    A JDK is required.

    You can get the official Oracle installers from:
    http://www.oracle.com/technetwork/java/javase/downloads/index.html
    EOS
  end
end

class Avian < Formula
  homepage 'http://oss.readytalk.com/avian/'
  url 'http://oss.readytalk.com/avian/avian-0.6.tar.bz2'
  sha1 '763e1d99af624416aac60f0e222df938aaa3510b'

  head 'https://github.com/ReadyTalk/avian.git'

  depends_on JdkInstalled
  depends_on LionOrNewer

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
    %x[avian Test] == 'OK'
  end
end
