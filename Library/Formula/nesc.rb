class Nesc < Formula
  desc "Programming language for deeply networked systems"
  homepage "http://nescc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/nescc/nescc/v1.3.4/nesc-1.3.4.tar.gz"
  sha256 "870f06797bc945523918d6318386f0b717d799f9c90adce645da246caa959558"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
