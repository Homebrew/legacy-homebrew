require 'formula'

class Nimrod < Formula
  homepage 'http://nimrod-code.org/'
  url 'http://nimrod-code.org/download/nimrod_0.9.2.zip'
  sha1 '326ecd61d6df45afdc04cb8685ef46f8fb8f9e47'

  head 'https://github.com/Araq/Nimrod.git'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end
end
