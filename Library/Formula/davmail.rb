class Davmail < Formula
  desc "POP/IMAP/SMTP/Caldav/Carddav/LDAP exchange gateway"
  homepage "http://davmail.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/davmail/davmail/4.5.1/davmail-4.5.1-2303.zip"
  sha256 "d69f0c8cf6cf5b76c1fb0ff82fe7cecd22d470c83206fa3fecbe486c758c080d"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"davmail.jar", "davmail"
  end
end
