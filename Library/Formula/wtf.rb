class Wtf < Formula
  desc "Translate common Internet acronyms"
  homepage "http://cvsweb.netbsd.org/bsdweb.cgi/src/games/wtf/"
  url "https://downloads.sourceforge.net/project/bsdwtf/wtf-20141212.tar.gz"
  sha256 "31ee95558aee74f76d9e531fb2489765eb51c963b7b514cc07f8b407baf7f2a2"

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
