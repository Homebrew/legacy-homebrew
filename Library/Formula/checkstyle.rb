require 'formula'

class Checkstyle < Formula
  homepage 'http://checkstyle.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/checkstyle/checkstyle/5.7/checkstyle-5.7-bin.tar.gz'
  sha1 '232d317391b58d118a0102e8ff289fbaebd0064a'

  def install
    libexec.install "checkstyle-#{version}-all.jar", "sun_checks.xml"
    bin.write_jar_script libexec/"checkstyle-#{version}-all.jar", "checkstyle"
  end
end
