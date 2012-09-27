require 'formula'

class Nimrod < Formula
  homepage 'http://force7.de/nimrod/'
  url 'http://force7.de/nimrod/download/nimrod_0.8.14.zip'
  sha1 'e37e48bcec96c8baf578671c3f20cc5e1e8b0267'

  head 'https://github.com/Araq/Nimrod.git'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end
end
