# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class HazelcastCli < Formula
  homepage "github.com/hazelcast"
  url "http://download.hazelcast.com/enterprise/brew/hazelcast-cli-1.0.tar.gz"
  version "1.0"
  sha256 "92fc920b1523077dc23f898c24d292b81a6666ae0a10729bfe07f73f97a86270"

  # depends_on "cmake" => :build

  def install
   libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/hazelcast.sh" => "hazelcast"
  end

  test do
    system "false"
  end
end
