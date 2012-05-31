require 'formula'

class Nimrod < Formula
  homepage 'http://force7.de/nimrod/'
  url 'http://force7.de/nimrod/download/nimrod_0.8.14.zip'
  md5 '3b89c11e4071bf492134c8f4258ebd5d'

  head 'https://github.com/Araq/Nimrod.git'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end
end
