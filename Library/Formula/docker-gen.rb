class DockerGen < Formula
  desc "Generate files from docker container meta-data"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/releases/download/0.6.0/docker-gen-darwin-amd64-0.6.0.tar.gz"
  sha256 "034758ac33adda981dccffcabeaf8b7ab5c461c19cb9daf455ea276207bb66ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "2818b78c3f09503c3a6e73cec25fc2f8904ec6f446b322772d6683c2f4048459" => :el_capitan
    sha256 "fb9a79daa051f526f414f36e6e2b609bc767699da385030a49767d14035b40b6" => :yosemite
    sha256 "5e006090106182a3c7f8cac8feb128a90c7d9fc17fa749a786a7118f1e9f9369" => :mavericks
  end

  def install
    bin.install "docker-gen"
  end

  test do
    system "#{bin}/docker-gen", "--version"
  end
end
