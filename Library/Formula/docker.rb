require 'formula'

class Docker < Formula
  homepage 'http://docker.io/'
  url 'https://github.com/dotcloud/docker/archive/v0.5.2.tar.gz'
  sha1 'd8961d57a8de950ec30975ff9fa675f4da3bc27e'

  depends_on 'go' => :build

  def install
    system "make", "all"
    bin.install("bin/docker")
  end

  def caveats; <<-EOF.undent
    Docker is a client / server system, but the server doesn't (yet) run on
    Mac OS X. You can, however, run the client and point it at a Docker
    daemon running inside a Linux VM or remote host.

    To point the Docker client at a remote daemon instance:
        docker -H=tcp://docker.host:4243 [command]
    EOF
  end

  test do
    system "docker"
  end
end
