require 'formula'

class TestBall < Formula
  def initialize(name="test_ball", path=nil)
    self.class.instance_eval do
      stable.url "file:///#{TEST_FOLDER}/tarballs/testball-0.1.tbz"
      stable.sha1 "482e737739d946b7c8cbaf127d9ee9c148b999f5"
    end
    super
  end
  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end

class ConfigureFails < Formula
  url "file:///#{TEST_FOLDER}/tarballs/configure_fails.tar.gz"
  version '1.0.0'
  sha1 'b36c65e5de86efef1b3a7e9cf78a98c186b400b3'

  def initialize(name="configure_fails", path=nil)
    super
  end

  def install
    system "./configure"
  end
end
