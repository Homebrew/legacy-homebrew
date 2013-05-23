require 'formula'

class Mkpasswd < Formula
  homepage 'https://github.com/pivotalops/security'
  url 'https://github.com/pivotalops/security.git'
  sha1 'a62268959fc6bb499970b32ea5fba99269af3af1'
  version '0.0.1'

  def install
    system "cc", "-O0", "-o", "mkpasswd", "mkpasswd.c"
    bin.install "mkpasswd"
  end
end
