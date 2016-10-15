require "formula"

class Hugo < Formula
  homepage "http://hugo.spf13.com/"
  url "https://github.com/spf13/hugo/archive/v0.9.tar.gz"
  sha1 "ea231a3d5547e37c7c5be69e57ed7e32acc86b00"

  depends_on 'go' => :build
  depends_on 'bazaar' => :build

  def install
    # override any environmental vars, set our gopath to one we know will work
    ENV["GOPATH"] = "#{HOMEBREW_PREFIX}/var/go/gopath"

    system "go get github.com/spf13/hugo"
    system "cd #{HOMEBREW_PREFIX}/var/go/gopath"
    system "go build -o hugo main.go"

    # move the completed binary into the bin
    system "mv hugo #{HOMEBREW_PREFIX}/bin"
  end

  test do
    # run the help dialog to make sure it's installed properly
    system "#{HOMEBREW_PREFIX}/bin/hugo", "help"
  end
end
