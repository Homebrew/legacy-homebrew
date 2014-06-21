require 'formula'

class TestBall < Formula
  def initialize(name="test_ball", path=Pathname.new(__FILE__).expand_path, spec=:stable)
    self.class.instance_eval do
      stable.url "file://#{TEST_DIRECTORY}/tarballs/testball-0.1.tbz"
      stable.sha1 "482e737739d946b7c8cbaf127d9ee9c148b999f5"
    end
    super
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end
