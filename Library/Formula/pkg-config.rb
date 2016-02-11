class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://wiki.freedesktop.org/www/Software/pkg-config/"
  url "https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.tar.gz"
  mirror "https://fossies.org/linux/misc/pkg-config-0.29.tar.gz"
  sha256 "c8507705d2a10c67f385d66ca2aae31e81770cc0734b4191eb8c489e864a006b"

  bottle do
    sha256 "088515dbb9db3977859d895b20eff9f486120641280d3b3a51fefe751197ece9" => :el_capitan
    sha256 "0791826c3728850a60af3da2056140dd98d329564b3c18288f4a9a1e419e7db5" => :yosemite
    sha256 "0d7481570e257c4ed5125ed4ae5c6ee4dce475eda0e8935e4c5028bbbe81a5f2" => :mavericks
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
