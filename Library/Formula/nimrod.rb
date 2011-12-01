require 'formula'

class Nimrod < Formula
  url 'http://force7.de/nimrod/download/nimrod_0.8.12.zip'
  head 'https://github.com/Araq/Nimrod.git'
  homepage 'http://force7.de/nimrod/'
  md5 '2101fdff83339b4480ffe8fd12b934da'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end
end
