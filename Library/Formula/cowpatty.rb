class Cowpatty < Formula
  desc "Offline dictionary attack for WPA-PSK, WPA2-PSK networks"
  homepage "http://www.willhackforsushi.com/?page_id=50"
  url "http://www.willhackforsushi.com/code/cowpatty/4.6/cowpatty-4.6.tgz"
  sha256 "cd3fc113e5052d3ee08ab71aa87edf772d044f760670c73fde5d5581d7803bc2"

  bottle do
    cellar :any
    sha256 "59ac61fb2475e34b6a9dc80b1fc5d9e41f9f12a47811db60dcb1bd09a172b53d" => :el_capitan
    sha256 "efeef8d6749f377017fdb2e8774774e0d1f63fc9cdc934c5ea776b8fb3944421" => :yosemite
    sha256 "c3f6df9acc0a5a8db35e1c7ecaf80101a94cf790ad4b12ba89d506a2559f3a0f" => :mavericks
  end

  depends_on "openssl"

  resource "capture" do
    url "http://www.lovemytool.com/files/test.pcap"
    sha256 "35fba0f92c5e8fb0710453d0c2c5fe5e9c64857dd53b219977871340b22c4942"
  end

  def install
    # May fail on parallel builds with a race condition, see #45150
    ENV.deparallelize
    system "make", "BINDIR=#{bin}", "install"
  end

  test do
    (testpath/"dict").write <<-EOS.undent
      isthisthepassword?
      maybethisoneinstead
      subnet16121930
    EOS
    resource("capture").stage do
      system bin/"cowpatty", "-r", "test.pcap",
             "-f", testpath/"dict", "-s", "dd-wrt2"
    end
  end
end
