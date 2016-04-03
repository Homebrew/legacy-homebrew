class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.10.tar.xz"
  sha256 "6a206dc3d5149fe4a40fb47850fd55619de03c165c843caf61f84b840c623a93"

  bottle do
    sha256 "b509ae099d9f39a5c9beecec9397ca5edd55e632bc4a94f5e896fb27016f2621" => :el_capitan
    sha256 "766b3a13fdc77e8a98fb1989fb549f068475b80d675ab1341d993b9294d66010" => :yosemite
    sha256 "5035361df688340431fbce01ea01d9ae0e5945a46d4ae4e0f0d059037fb8ed5f" => :mavericks
  end

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
