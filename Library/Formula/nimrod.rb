require 'formula'

class Nimrod < Formula
  url 'http://force7.de/nimrod/download/nimrod_0.8.10.zip'
  head 'git://github.com/Araq/Nimrod.git'
  homepage 'http://force7.de/nimrod/'
  md5 'b32d08ff40d2e17eda39a3c1f1bc39f9'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end
end
