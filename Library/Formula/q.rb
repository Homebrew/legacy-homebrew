require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.1.4.tar.gz'
  sha1 '103571338e9bbbc8fe4acb3f0b474691a591ddf4'

  def install
    bin.install 'q'
  end
end

