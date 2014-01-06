require 'formula'

class Q < Formula
  homepage 'https://github.com/harelba/q'
  url 'https://github.com/harelba/q/archive/1.1.tar.gz'
  sha1 'ffbb14189526cf338a408b0ea4273c9528d9a63e'

  def install
    bin.install 'q'
  end
end

