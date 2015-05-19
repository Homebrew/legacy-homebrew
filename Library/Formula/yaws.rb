class Yaws < Formula
  desc "Webserver for dynamic content (written in Erlang)"
  homepage "http://yaws.hyber.org"
  url "https://github.com/klacke/yaws/archive/yaws-1.99.tar.gz"
  sha1 "ea407afe7b080ed065182d73503899a75360dfaf"
  head "https://github.com/klacke/yaws.git"

  bottle do
    sha1 "22a14414e75ac551799dfae222c65b13732e8e2a" => :yosemite
    sha1 "b8485c79ccb25b36a3591e5962389b5cd97c9eaa" => :mavericks
    sha1 "75802258262ab4a400136cb702a92f9b74904e81" => :mountain_lion
  end

  option "without-yapp", "Omit yaws applications"
  option "32-bit"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "erlang"

  # the default config expects these folders to exist
  skip_clean "var/log/yaws"
  skip_clean "lib/yaws/examples/ebin"
  skip_clean "lib/yaws/examples/include"

  def install
    if build.build_32_bit?
      ENV.append %w[CFLAGS LDFLAGS], "-arch #{Hardware::CPU.arch_32_bit}"
    end

    system "autoreconf", "-fvi"
    system "./configure", "--prefix=#{prefix}",
                          # Ensure pam headers are found on Xcode-only installs
                          "--with-extrainclude=#{MacOS.sdk_path}/usr/include/security"
    system "make", "install"

    if build.with? "yapp"
      cd "applications/yapp" do
        system "make"
        system "make", "install"
      end
    end

    # the default config expects these folders to exist
    (lib/"yaws/examples/ebin").mkpath
    (lib/"yaws/examples/include").mkpath

    (var/"log/yaws").mkpath
    (var/"yaws/www").mkpath
  end

  test do
    system bin/"yaws", "--version"
  end
end
