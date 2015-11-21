class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https://github.com/rackspace/rack"
  url "https://github.com/rackspace/rack.git",
      :tag => "1.0.1",
      :revision => "71a8d7c80b3652b4dd39e683bc423b8a542b0167"
  head "https://github.com/rackspace/rack.git"

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
