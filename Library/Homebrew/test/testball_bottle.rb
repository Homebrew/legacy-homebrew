class TestballBottle < Formula
  def initialize(name = "testball_bottle", path = Pathname.new(__FILE__).expand_path, spec = :stable)
    self.class.instance_eval do
      stable.url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
      stable.sha256 TESTBALL_SHA256
      stable.bottle do
        cellar :any_skip_relocation
        root_url "file://#{File.expand_path("..", __FILE__)}/bottles"
        sha256 "9abc8ce779067e26556002c4ca6b9427b9874d25f0cafa7028e05b5c5c410cb4" => bottle_tag
      end
      cxxstdlib_check :skip
    end
    super
  end

  def install
    prefix.install "bin"
    prefix.install "libexec"
  end
end
