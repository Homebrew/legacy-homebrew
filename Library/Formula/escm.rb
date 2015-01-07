class Escm < Formula
  homepage "http://practical-scheme.net/vault/escm.html"
  url "http://practical-scheme.net/vault/escm-1.1.tar.gz"
  sha1 "a1ddcbd88d9c26270f38c200abf5c8745c783faa"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir_p "#{bin}"
    system "make", "install"
  end

  test do
    system "#{bin}/escm", "-v"
  end
end
