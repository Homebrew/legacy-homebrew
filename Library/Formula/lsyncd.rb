class Lsyncd < Formula
  desc "Synchronize local directories with remote targets"
  homepage "https://github.com/axkibe/lsyncd"
  url "https://github.com/axkibe/lsyncd/archive/release-2.1.5.tar.gz"
  sha256 "aa82fd9bf5737395e374650720c02f033d74a7101b57878ac92f5720ae9e7ece"
  revision 2

  bottle do
    cellar :any
    revision 1
    sha256 "cb5c1552abebaeab45b6eda4b82e6485eb7b29f942280cc3d1f80a0a6d2f37bb" => :el_capitan
    sha256 "cc4ba0df4e6800542e34f0be4f65b470ed1d9b6940bbbde4d22ef2b219613496" => :yosemite
    sha256 "1a612fd37fbd78055217e6e4b29f6b2dd993c1c95d43db8b85f8c54750ba6121" => :mavericks
    sha256 "4b2f83284224b052348fde82b450e98b135c7fe5a8778fd1c57f44626096b0d2" => :mountain_lion
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
    "10.7.5" => ["xnu-1699.32.7.tar.gz",  "2163816aae990675d8f45cdced4b680bb112fb7a600eb0063af2c2bc2ea15e15"],
    "10.8"   => ["xnu-2050.7.9.tar.gz",   "25c8fc346d1c209f6d20b456dcb256f1e829e844f67b262c090caf088559f4b1"],
    "10.8.1" => ["xnu-2050.9.2.tar.gz",   "f342179c625413ae3a74fc1a5747fc555c1353cfef6259c595626469744a6405"],
    "10.8.2" => ["xnu-2050.18.24.tar.gz", "5d018b33efd9eebb05142958432b9a5058febe04a3b92ba5a16a285490a83445"],
    "10.8.3" => ["xnu-2050.22.13.tar.gz", "54011448f0cbb84792146657f4f5f8f64beca52e63bd0eb6028aadedf153a4d6"],
    "10.8.4" => ["xnu-2050.24.15.tar.gz", "24e6dc5d98d8f2be450832ea9cfaf2fc85c090422e5b89b24c2a80f0d2957a04"],
    "10.8.5" => ["xnu-2050.48.11.tar.gz", "454203188d19a368f850f335a6b4c8fbfc383e929116b2b06e63d8365ccd207e"],
    "10.9"   => ["xnu-2422.1.72.tar.gz",  "fbefe23943d0c4c12b3d7abd3f304224176f269b19ef6ad801314bc69cf773db"],
    "10.9.1" => ["xnu-2422.1.72.tar.gz",  "fbefe23943d0c4c12b3d7abd3f304224176f269b19ef6ad801314bc69cf773db"],
    "10.9.2" => ["xnu-2422.90.20.tar.gz",  "7bf3c6bc2f10b99e57b996631a7747b79d1e1684df719196db1e5c98a5585c23"],
    "10.9.3" => ["xnu-2422.100.13.tar.gz", "0deb3a323804a18e23261b1f770a7b85b6329213cb77f525d5a2663e8961d87a"],
    "10.9.4" => ["xnu-2422.110.17.tar.gz", "0b973913648d5773367f264002f7832bd01510687fa55a28ef1438c86affa141"],
    "10.9.5" => ["xnu-2422.115.4.tar.gz", "1a505922bbf232a616a7398e17eff4477fb0621a6c046ff802a2c7b7bf2b5ceb"],
    "10.10"  => ["xnu-2782.1.97.tar.gz", "18fd93155c53fa66c48c2c876313311bba55cff260ea10e7b67dd7ed1f4b945c"],
    "10.10.1"  => ["xnu-2782.1.97.tar.gz", "18fd93155c53fa66c48c2c876313311bba55cff260ea10e7b67dd7ed1f4b945c"],
    "10.10.2"  => ["xnu-2782.10.72.tar.gz", "0725dfc77ce245e37b57d226445217c17d0a7750db099d3ca69a4ad1c7f39356"],
    "10.10.3"  => ["xnu-2782.20.48.tar.gz", "75effef91dbeb7ab59da7a62936e37e30c2a2feca9ee653d3245b6a5b17ad2d7"],
    "10.10.4"  => ["xnu-2782.20.48.tar.gz", "75effef91dbeb7ab59da7a62936e37e30c2a2feca9ee653d3245b6a5b17ad2d7"],
    "10.10.5"  => ["xnu-2782.20.48.tar.gz", "75effef91dbeb7ab59da7a62936e37e30c2a2feca9ee653d3245b6a5b17ad2d7"],
    "10.11"  => ["xnu-2782.20.48.tar.gz", "75effef91dbeb7ab59da7a62936e37e30c2a2feca9ee653d3245b6a5b17ad2d7"],
  }

  # TODO: wrap MACOS_FULL_VERSION in a MacOS module method
  if xnu_headers.key? MACOS_FULL_VERSION
    tarball, checksum = xnu_headers.fetch(MACOS_FULL_VERSION)
    resource "xnu" do
      url "http://www.opensource.apple.com/tarballs/xnu/#{tarball}"
      sha256 checksum
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
