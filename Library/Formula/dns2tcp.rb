class Dns2tcp < Formula
  desc "TCP over DNS tunnel"
  homepage "http://www.hsc.fr/ressources/outils/dns2tcp/index.html.en"
  url "http://www.hsc.fr/ressources/outils/dns2tcp/download/dns2tcp-0.5.2.tar.gz"
  sha256 "ea9ef59002b86519a43fca320982ae971e2df54cdc54cdb35562c751704278d9"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match(/^dns2tcp v#{version} /,
                 shell_output("#{bin}/dns2tcpc -help 2>&1", 255))
  end
end
