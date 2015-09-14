class P7zip < Formula
  desc "7-Zip (high compression file archiver) implementation"
  homepage "http://p7zip.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/p7zip/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2"
  sha1 "1cd567e043ee054bf08244ce15f32cb3258306b7"

  devel do
    url "https://downloads.sourceforge.net/project/p7zip/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2"
    sha1 "6b1eccf272d8b141a94758f80727ae633568ba69"
  end

  bottle do
    revision 1
    sha256 "6da7c418d9a2339d2f80bbe05afd086ed4c3c82018bdd0daad296acb0e5f2dfa" => :yosemite
    sha256 "3fb6ca5b15e998d517eace9dd2f3be76ced1323e9af66eaefe1824e422c9cbf0" => :mavericks
    sha256 "1f55e602743aaf481d8f11b85069f87c0cdb02122cb2df13966b7871c7905fe3" => :mountain_lion
  end

  option "32-bit"

  def install
    if Hardware.is_32_bit? || build.build_32_bit?
      mv "makefile.macosx_32bits", "makefile.machine"
    else
      mv "makefile.macosx_64bits", "makefile.machine"
    end

    # install.sh chmods to 444, which is bad and breaks uninstalling
    inreplace "install.sh", /chmod (444|555).*/, ""

    system "make", "all3",
                   "CC=#{ENV.cc} $(ALLFLAGS)",
                   "CXX=#{ENV.cxx} $(ALLFLAGS)"
    system "make", "DEST_HOME=#{prefix}",
                   "DEST_MAN=#{man}",
                   "install"
  end
end
