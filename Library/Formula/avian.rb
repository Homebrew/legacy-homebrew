require 'formula'

class Avian < Formula
  homepage 'http://oss.readytalk.com/avian/'
  head 'https://github.com/ReadyTalk/avian.git'
  url 'https://github.com/ReadyTalk/avian/archive/v0.7.1.1.tar.gz'
  sha1 '326f127f146f46a5b35567b1717ea4a5b13833fd'

  depends_on :macos => :lion

  # Fix build with clang; already upstream
  patch do
    url "https://github.com/ReadyTalk/avian/commit/69ea1f57219e0ec1b113f1fcadaa3dae6b93f358.diff"
    sha1 "fc357efdd179c2511e76181dbf735e4a9e19e8b5"
  end

  def install
    system 'make', 'JAVA_HOME=/Library/Java/Home'
    bin.install Dir['build/darwin-*/avian*']
    lib.install Dir['build/darwin-*/*.dylib', 'build/darwin-*/*.a']
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
