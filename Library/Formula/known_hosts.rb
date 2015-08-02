require "formula"

class KnownHosts < Formula
  desc "Command-line manager for known hosts"
  homepage "https://github.com/markmcconachie/known_hosts"
  url "https://github.com/markmcconachie/known_hosts/archive/0.0.4.tar.gz"
  sha1 "72edc388949e761932f05815fcd6fda2224ccdd4"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/known_hosts version"
  end
end
