require 'language/go'

class Devd < Formula
    desc 'A http daemon for local development'
    homepage 'https://github.com/cortesi/devd'
    url 'https://github.com/cortesi/devd/archive/v0.1.tar.gz'
    version '0.1'
    sha256 '7ea5251b951159e0e58f314f7b46ed0d97788a19aa0aef6fdfb0f1f87dd8a98e'

    head 'https://github.com/cortesi/devd/devd.git'

    depends_on 'go' => :build

    def install
        ENV['GOPATH'] = buildpath

        # Install Go dependencies
        system 'go', 'get', 'github.com/cortesi/devd'
        system 'go', 'get', 'github.com/GeertJohan/go.rice'
        system 'go', 'get', 'github.com/toqueteos/webbrowser'
        system 'go', 'get', 'github.com/alecthomas/kingpin'

        system 'go', 'build', '-o', 'devd'
        bin.install 'devd'
    end

    test do
        system "#{bin}/devd", '--version'
    end
end
