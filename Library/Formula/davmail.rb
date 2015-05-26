require "formula"

class Davmail < Formula
  homepage "http://davmail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/4.5.1/davmail-4.5.1-2303.zip"
  sha1 "4b524832b432216d2b8dfa97198c50681a1734ce"

  def install
    libexec.install Dir['*']
    bin.write_jar_script libexec/"davmail.jar", "davmail"
  end
end
