# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class HazelcastCli < Formula
  homepage "github.com/hazelcast"
  url "http://download.hazelcast.com/enterprise/brew/hazelcast-cli-1.0.tar.gz"
  version "1.0"
  sha256 "dbe914190907c6c91adf0d9e0262e8164f59adb92e81e6efbb0e88134dea4275"

  # depends_on "cmake" => :build

  def install
   libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/hazelcast.sh" => "hazelcast"
  end

  test do
    system "false"
  end
end
