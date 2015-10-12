require "language/go"

class Emp < Formula
  desc "CLI for Empire."
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.10.0.tar.gz"
  sha256 "0f49543e25d44a05522f8e2cbb4afbb5b08153767620e304e371e13b8f574508"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/remind101/").mkpath
    ln_s buildpath, buildpath/"src/github.com/remind101/empire"

    system "go", "build", "-o", bin/"emp", "./src/github.com/remind101/empire/cmd/emp"
  end

  test do
    require "webrick"
    require "utils/json"

    server = WEBrick::HTTPServer.new :Port => 8035
    server.mount_proc "/apps/foo/releases" do |_req, res|
      resp = {
        "created_at" => "2015-10-12T0:00:00.00000000-00:00",
        "description" => "my awesome release",
        "id" => "v1",
        "user" => {
          "id" => "zab",
          "email" => "zab@waba.com",
        },
        "version" => 1,
      }
      res.body = Utils::JSON.dump([resp])
    end

    Thread.new { server.start }

    begin
      ENV["EMPIRE_API_URL"] = "http://127.0.0.1:8035"
      assert_match /v1  zab  Oct 1(1|2|3) \d\d:00  my awesome release/,
        shell_output("#{bin}/emp releases -a foo").strip
    ensure
      server.shutdown
    end
  end
end
