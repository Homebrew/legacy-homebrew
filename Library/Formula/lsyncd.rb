require "formula"

class Lsyncd < Formula
  homepage "https://github.com/axkibe/lsyncd"
  url "https://github.com/axkibe/lsyncd/archive/release-2.1.5.tar.gz"
  sha1 "2b8eb169365edc54488a97435bbd39ae4a6731b8"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  # This is an artificial requirement, the resource below is incomplete
  depends_on :macos => :lion

  xnu_headers = {
    "10.7.5" => ["xnu-1699.32.7.tar.gz",  "da3df48952b40ad3b8612c7f639b8bf0f92fb414"],
    "10.8"   => ["xnu-2050.7.9.tar.gz",   "9aaf1e0b0a148ff303577161fecaf3ea6188aa1b"],
    "10.8.1" => ["xnu-2050.9.2.tar.gz",   "2bd58959afc5ac8f2c9fa3d693882acc96b25321"],
    "10.8.2" => ["xnu-2050.18.24.tar.gz", "3a2a0b3629cb215b17aca3bb365b8b10b8b408fe"],
    "10.8.3" => ["xnu-2050.22.13.tar.gz", "a002806d1e64505c6a98c10af26186454818a9ff"],
    "10.8.4" => ["xnu-2050.24.15.tar.gz", "a080f28b7385b0cc63f9ba5a07d922d53ea0a4a3"],
    "10.8.5" => ["xnu-2050.48.11.tar.gz", "1f6860148f8231a53a6b393aa1af589cdedfc70c"],
    "10.9"   => ["xnu-2422.1.72.tar.gz",  "c7bdc40396df3c51ece934c0e3b4a19b063ea34c"],
    "10.9.1" => ["xnu-2422.1.72.tar.gz",  "c7bdc40396df3c51ece934c0e3b4a19b063ea34c"],
    "10.9.2" => ["xnu-2422.90.20.tar.gz",  "4aa6b80cc0ff6f9b27825317922b51c5f33d5bae"],
    "10.9.3" => ["xnu-2422.90.20.tar.gz",  "4aa6b80cc0ff6f9b27825317922b51c5f33d5bae"],
  }

  # TODO wrap MACOS_FULL_VERSION in a MacOS module method
  if xnu_headers.key? MACOS_FULL_VERSION
    tarball, checksum = xnu_headers.fetch(MACOS_FULL_VERSION)
    resource "xnu" do
      url "http://www.opensource.apple.com/tarballs/xnu/#{tarball}"
      sha1 checksum
    end
  end

  def install
    # XNU Headers
    resource("xnu").stage buildpath/"xnu"
    ENV.append "CPPFLAGS", "-Ixnu"

    ENV.append "XML_CATALOG_FILES", "#{Formula["docbook"].opt_prefix}/docbook/xml/4.5/catalog.xml"
    ENV["A2X"] = "#{Formula["asciidoc"].opt_bin}/a2x"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-fsevents",
                          "--without-inotify",
                          "--prefix=#{prefix}"
    system "make", "install"

  end

  test do
    system bin/"lsyncd", "--version"
  end
end
