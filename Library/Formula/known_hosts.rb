require "formula"

class KnownHosts < Formula
  homepage "https://github.com/markmcconachie/known_hosts"
  head "https://github.com/markmcconachie/known_hosts.git"
  sha1 "b21daf3c2f58b08fe862c465c5ad52b72ee362f3"

  def install
    system "make", "install"
  end

  test do
    system "#{bin}/known_hosts"
  end
end
