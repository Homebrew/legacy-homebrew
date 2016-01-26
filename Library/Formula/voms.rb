class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms-clients/archive/v3.0.6.tar.gz"
  sha256 "0faad42ca34ab6492d8db391a6ba31fed52bc79936d9e6f95ff736f92767b39a"

  bottle do
    cellar :any
    sha256 "1324515f992f331be76152f62d01ef9364f0654c82c0995fc8622748e7c7cdd6" => :el_capitan
    sha256 "eaa56dee0ee58a47babfdf49307d79fddd30d1273512f73021888f24f1d8ee08" => :yosemite
    sha256 "01ed7c6185bbd2609e958065c1d58bdd8617abccdcfd3d8875faae532d327dea" => :mavericks
  end

  depends_on :java
  depends_on "maven" => :build
  depends_on "openssl"

  def install
    system "mvn", "package", "-Dmaven.repo.local=$(pwd)/m2repo/", "-Dmaven.javadoc.skip=true"
    system "tar", "-xf", "target/voms-clients.tar.gz"
    share.install "voms-clients/share/java"
    man5.install Dir["voms-clients/share/man/man5/*.5"]
    man1.install Dir["voms-clients/share/man/man1/*.1"]
    bin.install Dir["voms-clients/bin/*"]
  end

  test do
    system "#{bin}/voms-proxy-info", "--version"
  end
end
