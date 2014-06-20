require 'formula'

class Checkstyle < Formula
  homepage 'http://checkstyle.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/checkstyle/checkstyle/5.7/checkstyle-5.7-bin.tar.gz'
  sha1 '232d317391b58d118a0102e8ff289fbaebd0064a'

  def install
    libexec.install "checkstyle-#{version}-all.jar", "sun_checks.xml"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end

  test do
    path = testpath/"foo.java"
    path.write "public class Foo{ }\n"

    output = `#{bin}/checkstyle -c #{libexec}/sun_checks.xml -r #{path}`
    errors = output.split("\n").select { |line| line.start_with?(path) }
    assert errors.include?("#{path}:1:17: '{' is not preceded with whitespace.")
    assert_equal errors.size, $?.exitstatus
  end
end
