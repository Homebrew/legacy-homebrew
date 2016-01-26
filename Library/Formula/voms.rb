class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms-clients/archive/v3.0.6.tar.gz"
  sha256 "0faad42ca34ab6492d8db391a6ba31fed52bc79936d9e6f95ff736f92767b39a"

  bottle :unneeded
  
  depends_on :java
  depends_on "maven" => :build
  depends_on "openssl"

  def install
    system "mvn", "package"
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
