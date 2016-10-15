require 'formula'

class Docker < Formula
  homepage 'http://www.docker.io'
  url 'http://test.docker.io/builds/Darwin/x86_64/docker-0.7.3.tgz'
  sha1 'cb77b6d69afc1d3c3e48486edd78cefd1f7a23d2'

  def install
    'unpack --destdir=.'
    bin.install('local/bin/docker')
  end

  test do
    system "#{bin}/docker", "version"
  end
end
