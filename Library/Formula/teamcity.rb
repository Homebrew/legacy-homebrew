class Teamcity < Formula
  desc "Extendable a popular continuous integration server that supports a variety of different version control systems and build runners."
  homepage "https://www.jetbrains.com/teamcity/"
  url "https://download.jetbrains.com/teamcity/TeamCity-9.1.4.tar.gz"
  version "9.1.4"
  sha256 "86766b3b813cdfdd22cd26248d57c8fc71b3178a4dc74e113bc53bd73e8ad5cf"

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["**/server-web-api.war"]
    bin.write_jar_script libexec/"DevPackage/server-web-api.war", "teamcity"
  end


  plist_options :manual => "teamcity"

end
