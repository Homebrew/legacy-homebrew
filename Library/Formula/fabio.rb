require "language/go"
require "socket"
require "timeout"

class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router."
  homepage "https://github.com/eBay/fabio"
  url "https://github.com/eBay/fabio/archive/v1.0.8.tar.gz"
  sha256 "32f771087cbd789293b655d7469e9a79d4f16c65956f81d54be8ff0fcf2d6e39"

  head "https://github.com/eBay/fabio.git"

  depends_on "go" => :build
  depends_on "consul" => :recommended

  def install
    mkdir_p buildpath/"src/github.com/ebay"
    ln_s buildpath, buildpath/"src/github.com/ebay/fabio"

    ENV["GOPATH"] = "#{buildpath}/_third_party:#{buildpath}"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "fabio"
    bin.install "fabio"
  end

  test do
    CONSUL_DEFAULT_PORT=8500
    FABIO_DEFAULT_PORT=9999
    LOCALHOST_IP="127.0.0.1".freeze

    if !Fabio.port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      if !Fabio.port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT) 
        exec "consul agent"
        sleep 5
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
      end
      sleep 10
      assert_equal true, Fabio.port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      exec "killall fabio" # fabio forks off from the fork...
    else
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    end
  end

  def self.port_open?(ip, port, seconds = 1)
    Timeout.timeout(seconds) do
      begin
        TCPSocket.new(ip, port).close
        true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        false
      end
    end
  rescue Timeout::Error
    false
  end
end
