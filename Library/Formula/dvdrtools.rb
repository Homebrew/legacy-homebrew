class Dvdrtools < Formula
  desc "Fork of cdrtools DVD writer support"
  homepage "http://savannah.nongnu.org/projects/dvdrtools/"
  url "http://savannah.nongnu.org/download/dvdrtools/dvdrtools-0.2.1.tar.gz"
  sha256 "053d0f277f69b183f9c8e8c8b09b94d5bb4a1de6d9b122c0e6c00cc6593dfb46"

  conflicts_with "cdrtools",
    :because => "both cdrtools and dvdrtools install binaries by the same name"

  patch :p0 do
    url "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-cdda2wav-cdda2wav.c"
    sha256 "f792a26af38f63ee1220455da8dba2afc31296136a97c11476d8e3abe94a4a94"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-cdrecord-cdrecord.c"
    sha256 "c7f182ce154785e19235f30d22d3cf56e60f6c9c8cc953a9d16b58205e29a039"
  end

  patch :p0 do
    url "https://trac.macports.org/export/89262/trunk/dports/sysutils/dvdrtools/files/patch-scsi-mac-iokit.c"
    sha256 "f31253e021a70cc49e026eed81c5a49166a59cb8da1a7f0695fa2f26c7a3d98f"
  end

  def install
    ENV["LIBS"] = "-framework IOKit -framework CoreFoundation"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
