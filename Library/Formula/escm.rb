class Escm < Formula
  homepage "http://practical-scheme.net/vault/escm.html"
  url "http://practical-scheme.net/vault/escm-1.1.tar.gz"
  sha1 "a1ddcbd88d9c26270f38c200abf5c8745c783faa"

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make", "install"
    man1.install "escm.1"
    prefix.install "escm.esc"
  end

  test do
    system bin/"escm", "-E", prefix/"escm.esc"
  end
end
