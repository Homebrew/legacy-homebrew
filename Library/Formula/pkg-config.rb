class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://freedesktop.org/wiki/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.1.tar.gz"
  mirror "https://fossies.org/linux/misc/pkg-config-0.29.1.tar.gz"
  sha256 "beb43c9e064555469bd4390dcfd8030b1536e0aa103f08d7abf7ae8cac0cb001"

  bottle do
    sha256 "6bf11398f37f686faf47bf5fa96138423950428cd08316d9f0edcce6cda53561" => :el_capitan
    sha256 "8b908a88bf6a073824861647a074244fa24997f502ba3ac6a55411e05b54e736" => :yosemite
    sha256 "a27ddccd93c19c3e492c6dba674140340b9ac18253066b5a91933d7ca4dd0992" => :mavericks
  end

  def install
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
      /usr/local/lib/pkgconfig
      /usr/lib/pkgconfig
      #{HOMEBREW_LIBRARY}/ENV/pkgconfig/#{MacOS.version}
    ].uniq.join(File::PATH_SEPARATOR)

    ENV.append "LDFLAGS", "-framework Foundation -framework Cocoa"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pkg-config", "--libs", "openssl"
  end
end
