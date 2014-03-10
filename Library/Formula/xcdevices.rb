require "formula"

class Xcdevices < Formula
  homepage "https://github.com/neilco/xcdevices"
  url "https://github.com/neilco/xcdevices/archive/1.0.tar.gz"
  sha1 "3dc3fe6a1a706b607bd2dfcad2e497a740f92708"

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    
    args = %w(build -o xcdevices xcdevices.go)
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    
    bin.install 'xcdevices'
  end

  test do
    system "#{bin}/xcdevices --help"
  end
end
