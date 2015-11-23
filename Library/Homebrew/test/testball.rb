class Testball < Formula
  def initialize(name = "testball", path = Pathname.new(__FILE__).expand_path, spec = :stable)
    self.class.instance_eval do
      stable.url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
      stable.sha256 "1dfb13ce0f6143fe675b525fc9e168adb2215c5d5965c9f57306bb993170914f"
    end
    super
  end

  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end
