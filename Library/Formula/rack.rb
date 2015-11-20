class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https://github.com/rackspace/rack"
  url "https://github.com/rackspace/rack.git",
      :tag => "1.0.1",
      :revision => "71a8d7c80b3652b4dd39e683bc423b8a542b0167"
  head "https://github.com/rackspace/rack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20b5623a5d690e48337504081504e75dc841a7cef3b4f1f7430e0c41e85562e4" => :el_capitan
    sha256 "e514e03dfb4c556b161c9fa2d2be4c2953549c5c060c11d274f8a1eacaa75fa5" => :yosemite
    sha256 "10c96e3863e45ac0761df401f28fc905c8c40532d4693e9be4bcc47c5b2a3615" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TRAVIS_TAG"] = version

    rackpath = buildpath/"src/github.com/rackspace/rack"
    rackpath.install Dir["{*,.??*}"]

    cd rackpath do
      system "script/build", "rack"
      bin.install "rack"
    end
  end

  test do
    system "#{bin}/rack"
  end
end
