class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "http://www.eyrie.org/~eagle/software/remctl/"
  url "http://archives.eyrie.org/software/kerberos/remctl-3.9.tar.gz"
  sha256 "7652a38008386a2cab4ba6f596ab0620a83a2b076dd56e74d01bbb9cddaed20e"

  depends_on "pcre"
  depends_on "libevent"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
