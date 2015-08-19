class KnownHosts < Formula
  desc "Command-line manager for known hosts"
  homepage "https://github.com/markmcconachie/known_hosts"
  url "https://github.com/markmcconachie/known_hosts/archive/0.0.4.tar.gz"
  sha256 "8608f798a860c8dc47ca2be6b1976bb56f8d70a8293a5a22544ad2b7ccdef1ed"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/known_hosts version"
  end
end
