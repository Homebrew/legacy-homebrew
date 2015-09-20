class Aide < Formula
  desc "File and directory integrity checker"
  homepage "http://aide.sourceforge.net"
  url "https://downloads.sourceforge.net/project/aide/devel/0.16a2/aide-0.16a2.tar.gz"
  sha256 "b52451816bc85409ea09dc612e32823336f78438afd28248c252912ea8b91b87"
  head "http://git.code.sf.net/p/aide/code.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libgcrypt" => :build

  def install
    system "sh", "./autogen.sh" if build.head?

    system "./configure", "--disable-lfs",
                          "--disable-static",
                          "--with-curl",
                          "--with-zlib",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/aide", "--version"
  end
end
