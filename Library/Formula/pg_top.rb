class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "http://ptop.projects.postgresql.org/"
  url "http://pgfoundry.org/frs/download.php/3504/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"

  depends_on :postgresql

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "echo '#define HAVE_DECL_STRLCPY 1' >> config.h" if MacOS.version >= :mavericks
    system "make", "install"
  end
end
