class PkgConfig < Formula
  desc "Manage compile and link flags for libraries"
  homepage "https://wiki.freedesktop.org/www/Software/pkg-config/"
  url "http://pkgconfig.freedesktop.org/releases/pkg-config-0.29.tar.gz"
  mirror "https://fossies.org/linux/misc/pkg-config-0.29.tar.gz"
  sha256 "c8507705d2a10c67f385d66ca2aae31e81770cc0734b4191eb8c489e864a006b"

  bottle do
    revision 2
    sha256 "094a16229d94915e12e4277946c3b7a8fac9484e4e40d970cc0457ef5f060acd" => :el_capitan
    sha1 "e9bcac1cfab9343a9e0c6d10a70b2797310d7706" => :yosemite
    sha1 "809937fdb5faaa3170f0abfc810ff244207d8975" => :mavericks
    sha1 "a0cbbdbe64aa3ffe665f674d68db8fb6fb84f7df" => :mountain_lion
    sha1 "44ec3ac051189dcd1e782cb7175979812f018e97" => :lion
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
