require "language/go"

class Urbano < Formula
  desc "Urbano - Urban Dictionary on the command line."
  homepage "https://github.com/ChubbsSolutions/urbano"
  url "https://github.com/ChubbsSolutions/urbano/archive/v0.3.tar.gz"
  version "0.3"
  sha256 "c0c5c2b20db0630048362c50802c3511cf76d26aa47b6d8d38fe51112c136329"

  depends_on "go" => :build

  urbano_deps = %w[
    github.com/codegangsta/cli c75c9d0182a18009e2ab4a7e71457e94c3621384
    github.com/mailgun/mailgun-go 56726ce4cd9da46e8d8b10a7257d12f69752b67d
    github.com/ttacon/chalk e66ca4d608eb6dc36d012bceeb08ef9f379134c1
    github.com/mbanzon/simplehttp 04c542e7ac706a25820090f274ea6a4f39a63326
  ]

  urbano_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    mkdir_p buildpath/"src/github.com/ChubbsSolutions/"
    ln_s buildpath, buildpath/"src/github.com/ChubbsSolutions/urbano"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "urbano"

    bin.install "urbano"
  end

  test do
    system "#{bin}/urbano", "help"
  end
end
