require "formula"

class Massren < Formula
  homepage "https://github.com/laurent22/massren"
  url "https://github.com/laurent22/massren/archive/v1.0.1.tar.gz"
  sha1 "0d8ee02fdf49fb42b0c5fe40c977ebdda5e4c3d9"

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    system 'go', 'get', 'github.com/jessevdk/go-flags'
    system 'go', 'get', 'github.com/kr/text'
    system 'go', 'get', 'github.com/laurent22/go-sqlkv'
    system 'go', 'get', 'github.com/mattn/go-sqlite3'
    system 'go', 'build', '-o', 'massren'
    bin.install 'massren'
  end
end
