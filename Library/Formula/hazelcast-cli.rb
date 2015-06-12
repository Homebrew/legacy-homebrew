# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class HazelcastCli < Formula
  homepage "github.com/hazelcast"
  url "http://download.hazelcast.com/enterprise/brew/hazelcast-cli-1.0.tar.gz"
  version "1.0"
  sha256 "03f9c9147b46f3d5544aaa75e44eb33292d03086c93e58b6bccd09ce83ca7b2c"

  # depends_on "cmake" => :build

  def install
   libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/hazelcast.sh" => "hazelcast"
  end

  test do
    system "false"
  end
end
