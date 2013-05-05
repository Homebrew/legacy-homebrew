require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.0.tar.gz'
  sha1 'f5cf21d14f26127cea6b6b069fcc2c7387c41af6'

  def install

    inreplace 'xctool.sh', /XCTOOL_DIR=.*/, "XCTOOL_DIR=#{prefix}"
    inreplace 'xctool.sh', /REVISION=.*/, "REVISION="
    inreplace 'build.sh', /REVISION=.*/, "REVISION="
    inreplace 'build_needed.sh', /REVISION=.*/, "REVISION="

    system './build.sh'

    bin.install 'xctool.sh'

    prefix.install Dir['*']

  end

end
