require 'formula'

class Gocode < Formula
  head 'https://github.com/nsf/gocode.git'
  url 'https://github.com/nsf/gocode.git', :tag => 'compatible-with-go-release.r60'
  homepage 'https://github.com/nsf/gocode'

  version 'r60'

  skip_clean ['bin']

  def install
    system "gomake"
    bin.mkpath
    bin.install "gocode"
  end

  def caveats; <<-EOS.undent
    This version of gocode is compatible with any go compiler at revision r60.x.
    EOS
  end
end