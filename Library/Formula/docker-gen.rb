class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/releases/download/0.7.0/docker-gen-darwin-amd64-0.7.0.tar.gz"
  sha256 "2778638defc63ed66d42e4dd099bd462eae1048492434b49b04b54453fc4b9f7"

  bottle :unneeded

  def install
    bin.install "docker-gen"
  end

  test do
    system "#{bin}/docker-gen", "--version"
  end
end
