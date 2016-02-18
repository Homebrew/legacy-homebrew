class DockerGen < Formula
  desc "Generate files from docker container meta-data"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/releases/download/0.6.0/docker-gen-darwin-amd64-0.6.0.tar.gz"
  sha256 "034758ac33adda981dccffcabeaf8b7ab5c461c19cb9daf455ea276207bb66ae"

  def install
    bin.install "docker-gen"
  end

  test do
    system "#{bin}/docker-gen", "--version"
  end
end
