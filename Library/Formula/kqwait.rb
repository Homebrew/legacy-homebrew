require 'formula'

class Kqwait < Formula
  homepage 'https://github.com/sschober/kqwait'
  url 'https://github.com/sschober/kqwait/archive/kqwait-v1.0.3.tar.gz'
  sha1 '47d12184dc67b7d16ca2895c0ce0de5937fa20cb'

  head 'https://github.com/sschober/kqwait.git'

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system "#{bin}/kqwait", "-v"
  end
end
