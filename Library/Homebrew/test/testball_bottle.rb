class TestballBottle < Formula
  def initialize(name = "testball_bottle", path = Pathname.new(__FILE__).expand_path, spec = :stable)
    self.class.instance_eval do
      stable.url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
      stable.sha256 "1dfb13ce0f6143fe675b525fc9e168adb2215c5d5965c9f57306bb993170914f"
      stable.bottle do
        cellar :any_skip_relocation
        root_url "file://#{File.expand_path("..", __FILE__)}/bottles"
        sha256 "9abc8ce779067e26556002c4ca6b9427b9874d25f0cafa7028e05b5c5c410cb4" => bottle_tag
      end
      cxxstdlib_check :skip
    end
    super
  end
end
