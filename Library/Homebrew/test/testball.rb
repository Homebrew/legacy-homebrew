require 'formula'

class TestBall <Formula
  # name parameter required for some Formula::factory
  def initialize name=nil
    @url="file:///#{TEST_FOLDER}/testball-0.1.tbz"
    @homepage = 'http://example.com/'
    super "testball"
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end
