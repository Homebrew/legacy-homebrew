class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "http://ditaa.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip"
  sha256 "d689e933b80b065cd7c349e489cfb8feea69dd3e91ca78931edc6fa6e098e689"

  bottle :unneeded

  def install
    libexec.install "ditaa0_9.jar"
    bin.write_jar_script libexec/"ditaa0_9.jar", "ditaa"
  end
end
