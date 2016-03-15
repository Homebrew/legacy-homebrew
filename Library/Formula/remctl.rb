class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "http://www.eyrie.org/~eagle/software/remctl/"
  url "http://archives.eyrie.org/software/kerberos/remctl-3.10.tar.xz"
  sha256 "6a206dc3d5149fe4a40fb47850fd55619de03c165c843caf61f84b840c623a93"

  depends_on "pcre"
  depends_on "libevent"

  def install
    # needed for gss_oid_equal()
    ENV.append "LDFLAGS", "-framework GSS"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
