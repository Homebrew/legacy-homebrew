require 'formula'

class Checkstyle < Formula
  homepage 'http://checkstyle.sourceforge.net/'
  url 'http://sourceforge.net/projects/checkstyle/files/checkstyle/5.5/checkstyle-5.5-bin.tar.gz'
  sha1 '757f89f0bb6148718904577d230a9b4f8221b03c'

  def install
    libexec.install 'checkstyle-5.5-all.jar', 'sun_checks.xml'
    bin.write_jar_script libexec/'checkstyle-5.5-all.jar', 'checkstyle'
  end

  test do
    # Note this test "fails" because the audit has issues
    # TODO - pipe through cat to ingore error code
    (testpath/"Test.java").write <<-EOS.undent
        public class Test{ }
    EOS
    system "#{bin}/checkstyle", "-c", "#{libexec}/sun_checks.xml", "-r", "Test.java"
  end
end
