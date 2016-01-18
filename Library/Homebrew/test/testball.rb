class Testball < Formula
  def initialize(name = "testball", path = Pathname.new(__FILE__).expand_path, spec = :stable)
    self.class.instance_eval do
      stable.url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
      stable.sha256 TESTBALL_SHA256
    end
    super
  end

  def install
    prefix.install "bin"
    prefix.install "libexec"
    Dir.chdir "doc"
  end
end
