class Cowpatty < Formula
  desc "Offline dictionary attack for WPA-PSK, WPA2-PSK networks"
  homepage "http://www.willhackforsushi.com/?page_id=50"
  url "http://www.willhackforsushi.com/code/cowpatty/4.6/cowpatty-4.6.tgz"
  sha256 "cd3fc113e5052d3ee08ab71aa87edf772d044f760670c73fde5d5581d7803bc2"

  depends_on "openssl"

  resource "capture" do
    url "http://www.lovemytool.com/files/test.pcap"
    sha256 "35fba0f92c5e8fb0710453d0c2c5fe5e9c64857dd53b219977871340b22c4942"
  end

  def install
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
