require 'formula'

class Unoconv < Formula
  homepage 'http://dag.wieers.com/home-made/unoconv/'
  url 'https://github.com/dagwieers/unoconv/archive/0.6.tar.gz'
  sha1 '28b35f6318f6269283a3a30efa87bc26ab00cf62'

  def install
    system "make", "prefix=#{HOMEBREW_PREFIX}", "install"
  end

  def test
    system "unoconv"
  end
end
