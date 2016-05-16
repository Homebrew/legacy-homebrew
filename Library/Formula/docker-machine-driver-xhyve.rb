require "language/go"

class DockerMachineDriverXhyve < Formula
  desc "Docker Machine driver for xhyve"
  homepage "https://github.com/zchee/docker-machine-driver-xhyve"
  url "https://github.com/zchee/docker-machine-driver-xhyve.git", 
    :tag => "v0.2.2",
    :revision => "7a7e30b80a9ee444e5e67fd1839422e201a1b328"
  head "https://github.com/zchee/docker-machine-driver-xhyve.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "d6550fd4f152d40760e7e2ab008b6a376aeeb05c1e81fb1dc29997c028b10075" => :el_capitan
    sha256 "8806ff664735c5a5ea06e0ab675d8f47bea87c0e42fcc9219a3e212e1bdc17c8" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on "go" => :build
  depends_on "docker-machine" => :recommended
  def caveats
    a = <<-EOS.undent
        This driver requires superuser privileges to access the hypervisor. To
        enable, execute
            sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
            sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
      EOS
    a
  end

  def install
    (buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve").install Dir["{*,.git,.gitignore,.gitmodules}"]

    ENV["GOPATH"] = "#{buildpath}/gopath"
    build_root = buildpath/"gopath/src/github.com/zchee/docker-machine-driver-xhyve"
    cd build_root do
      if build.head?
        git_hash = `git rev-parse --short HEAD --quiet`.chomp
        git_hash = "HEAD-#{git_hash}"
        ENV["CGO_LDFLAGS"] = "#{build_root}/vendor/build/lib9p/lib9p.a -L#{build_root}/vendor/lib9p"
        ENV["CGO_CFLAGS"] = "-I#{build_root}/vendor/lib9p"
        system "make", "lib9p"
      end
      system "go", "build", "-x", "-o", bin/"docker-machine-driver-xhyve",
      "-ldflags",
      "'-w -s'",
      "-ldflags",
      "-X 'github.com/zchee/docker-machine-driver-xhyve/xhyve.GitCommit=Homebrew#{git_hash}'",
      "./main.go"
    end
  end

  test do
    assert_match "xhyve-memory-size",
    shell_output("#{Formula["docker-machine"].bin}/docker-machine create --driver xhyve -h")
  end
end
