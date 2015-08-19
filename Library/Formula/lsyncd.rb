class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/axkibe/lsyncd"
  url "https://github.com/axkibe/lsyncd/archive/release-2.1.5.tar.gz"
  sha256 "aa82fd9bf5737395e374650720c02f033d74a7101b57878ac92f5720ae9e7ece"
  revision 2

  bottle do
    cellar :any
    sha1 "f42be91eff9963543d9b42a34f8cf5b6be720152" => :yosemite
    sha1 "9519e202543d0f371f4f9827e707937e23442854" => :mavericks
    sha1 "cb180347af72d91152cfb510f2f7f583543bf4f5" => :mountain_lion
  end

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
    "10.9.3" => ["xnu-2422.100.13.tar.gz", "3c02b0b43947d4af3363ada0c77310d4c1e501b5"],
    "10.9.4" => ["xnu-2422.110.17.tar.gz", "64eff89852eaa10b298ee58c0a1c92da8283f459"],
    "10.9.5" => ["xnu-2422.115.4.tar.gz", "48207e250422be7e78d238cd8b4d741ac98856df"],
    "10.10"  => ["xnu-2782.1.97.tar.gz", "c99cf8ec04c29d40b771652241dd325e4977d92b"],
    "10.10.1"  => ["xnu-2782.1.97.tar.gz", "c99cf8ec04c29d40b771652241dd325e4977d92b"],
    "10.10.2"  => ["xnu-2782.1.97.tar.gz", "c99cf8ec04c29d40b771652241dd325e4977d92b"]
  }

  # TODO: wrap MACOS_FULL_VERSION in a MacOS module method
  if xnu_headers.key? MACOS_FULL_VERSION
    tarball, checksum = xnu_headers.fetch(MACOS_FULL_VERSION)
    resource "xnu" do
      url "http://www.opensource.apple.com/tarballs/xnu/#{tarball}"
      sha1 checksum
    end
  end

  # patch for CVE-2014-8990
  # https://github.com/axkibe/lsyncd/commit/e9ffda07f0145f50f2756f8ee3fb0775b455122b
  # https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2014-8990
  patch do
    url "https://gist.githubusercontent.com/tdsmith/d807811d3c6965b0221e/raw/965545662eec39b60d50645487e6ade9d7d43834/cve-2014-8990.diff"
    sha256 "c6476855acaefd4619bd6900751247c2af12983ed2aff9bdfbf971ffcb662fc2"
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
