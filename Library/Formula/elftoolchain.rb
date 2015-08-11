class Elftoolchain < Formula
  desc "Compilation tools and libaries for handling the ELF file format"

  homepage "http://elftoolchain.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/elftoolchain/Sources/elftoolchain-0.6.1/elftoolchain-0.6.1.tgz"
  sha256 "f4dc6e2a820f146658d6b5f9a062a2e676d0715aca654f55866c60e0025561eb"

  depends_on :bsdmake => :build
  depends_on "libarchive"

  keg_only <<-EOS.undent
    The tools provided conflict with tool names from the normal toolchain, such
    as nm, and are not replacements for them.
  EOS

  # elftoolchain is in general pretty unaware of OS X / Darwin. The next 4
  # patches are pulled in from MacPorts to, e.g., make it aware of how to do
  # byte swapping.
  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-common-elftc.diff?rev=98117&format=raw"
    sha256 "e00505d7ffc62df5e20cb285ae4b27d3ab3c8948fe79d0f5637bed2326400214"
  end

  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-byteorder-macros.diff?rev=98117&format=raw"
    sha256 "a46bd66f14723aebba84932a295626374d314d1afe3ba684be7d0661c366c9de"
  end

  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-libelf-config.diff?rev=98117&format=raw"
    sha256 "a5e76d9383c70e870ff32bfd7fc52c8c4cdeca04410ee2f823d11bd9aba26c58"
  end

  patch :p0 do
    url "https://trac.macports.org/browser/trunk/dports/devel/elftoolchain/files/patch-mk.diff?rev=98117&format=raw"
    sha256 "aa7668354ae13930fde1c3c7acae98d9098a9356b998801eb65e2e4323b58cb2"
  end

  def install
    inreplace "mk/elftoolchain.prog.mk", "@PREFIX@", prefix

    args = %W[
      prefix=#{prefix}
      BINDIR=#{bin}
      LIBDIR=#{lib}
      SHLIBDIR=#{lib}
      INCSDIR=#{include}
      SHAREDIR=#{share}
      BINOWN=#{ENV["USER"]}
      SHAREOWN=#{ENV["USER"]}
      STRIP=
    ]

    system "bsdmake", "MKTEX=no", *args

    bin.mkpath
    include.mkpath
    lib.mkpath
    man1.mkpath
    man3.mkpath
    man5.mkpath

    system "bsdmake", "install", *args
  end

  test do
    system "#{bin}/readelf", "--version"
  end
end
