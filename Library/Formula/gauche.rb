class Gauche < Formula
  desc "R5RS Scheme implementation, developed to be a handy script interpreter"
  homepage "http://practical-scheme.net/gauche/"
  url "https://downloads.sourceforge.net/gauche/Gauche/Gauche-0.9.4.tgz"
  sha256 "7b18bcd70beaced1e004594be46c8cff95795318f6f5830dd2a8a700410fc149"

  bottle do
    revision 1
    sha256 "4018f9ae2b0a179ef5df0482e6734186f0069e773496f2f6092971f10a4c7b11" => :yosemite
    sha256 "e1258b3e8f0c5a61c8df484e173837e6fb3c7ecad7cd1fee277d1f8da56e98f9" => :mavericks
    sha256 "ffd47c0dcb63a508ae95adfc1e9c7825e75dd40fa10e46c68fcb8bd9b00637d5" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("gosh -V")
    assert_match /Gauche scheme shell, version #{version}/, output
  end
end
