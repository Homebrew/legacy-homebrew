class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20160128.tar.gz"
  sha256 "90ee20384bc3c6e1795f0f55aceb13fa199d8c48be9810ae6b6dfa8b308ccdd5"

  bottle :unneeded

  def install
    inreplace %w[wtf wtf.6], "/usr/share", share
    bin.install "wtf"
    man6.install "wtf.6"
    (share+"misc").install %w[acronyms acronyms.comp]
  end

  test do
    system bin/"wtf", "needle"
  end
end
