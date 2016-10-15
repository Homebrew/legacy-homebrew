require "language/go"

class Cyclops < Formula
  desc "Docker-powered REPL for scripting and automation"
  homepage "https://github.com/thisendout/cyclops"
  url "https://github.com/thisendout/cyclops/archive/v0.1.0.tar.gz"
  sha256 "93e636c67f644917410d8df04c5c46fb21e9ac69b9fe4ebbdfdda00010d0cdf8"

  depends_on "go" => :build

  go_resource project do
    url "https://github.com/mitchellh/gox.git", :revision => 'a5a468f84d74eb51ece602cb113edeb37167912f'
  end

  go_resource project do
    url "https://github.com/mitchellh/iochan.git", :revision => '87b45ffd0e9581375c491fef3d32130bb15c5bd7'
  end

  def install
    cyclopspath = buildpath/"src/github.com/thisendout/cyclops"
    ENV["GOPATH"] = "#{cyclopspath}/Godeps/_workspace:#{buildpath}"
    ENV.append_path "PATH", buildpath

    cyclopspath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd cyclopspath do
      system "go", "test", "./..."

      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-arch", arch,
        "-os", "darwin",
        "-output", "bin/cyclops-{{.Dir}}",
        "./..."
      bin.install "bin/cyclops-cyclops" => "cyclops"
    end
  end

  test do
    assert_equal "DOCKER_HOST must be set\n", shell_output("#{bin}/cyclops")
  end
end
