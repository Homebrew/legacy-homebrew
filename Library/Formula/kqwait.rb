require 'formula'

class Kqwait < Formula
  homepage 'https://github.com/sschober/kqwait'
  url 'https://github.com/sschober/kqwait.git', :tag => 'kqwait-v1.0.3'
  sha1 '7b4e762de8867593b21b06908a6ee13dbc1c863a'

  head 'https://github.com/sschober/kqwait.git'

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system "#{bin}/kqwait", "-v"
  end
end
