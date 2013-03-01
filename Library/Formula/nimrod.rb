require 'formula'

class Nimrod < Formula
  homepage 'http://nimrod-code.org/'
  url 'http://nimrod-code.org/download/nimrod_0.9.0.zip'
  sha1 '5fdfcfa8ccab19093ec0d01fc0d956e6a273f13f'

  head 'https://github.com/Araq/Nimrod.git'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end
end
