require "formula"

class Hashcash < Formula
  homepage "http://hashcash.org"
  url "http://hashcash.org/source/hashcash-1.22.tgz"
  sha1 "0fa03c9f266026e505c0ab7b671ad93aef9310de"

  def install
    system "make", "install",
                   "PACKAGER=HOMEBREW",
                   "INSTALL_PATH=#{bin}",
                   "MAN_INSTALL_PATH=#{man1}",
                   "DOC_INSTALL_PATH=#{doc}"
  end

  test do
    system "#{bin}/hashcash", "-mb10", "test@example.com"
  end
end
