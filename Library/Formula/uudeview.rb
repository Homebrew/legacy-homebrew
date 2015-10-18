class Uudeview < Formula
  desc "Smart multi-file multi-part decoder"
  homepage "http://www.fpx.de/fp/Software/UUDeview/"
  url "http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz"
  sha256 "e49a510ddf272022af204e96605bd454bb53da0b3fe0be437115768710dae435"
  revision 1

  bottle do
    sha256 "2692468b933a114f9f2cdebdb566ace98a5d33694fa6133e5024df5e4022a63f" => :yosemite
    sha256 "632df808fdc10ec4f8dbc18c028b51f6c28152fe0cc00c4b2a19a723f0b0499b" => :mavericks
    sha256 "880ad715f426a3284778d05138b45af606e8a7e78bd3aff4bd6e96fe9020f22d" => :mountain_lion
  end

  # Fix function signatures (for clang)
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/19da78c/uudeview/inews.c.patch"
    sha256 "4bdf357ede31abc17b1fbfdc230051f0c2beb9bb8805872bd66e40989f686d7b"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-tcl"
    system "make", "install"
    # uudeview provides the public library libuu, but no way to install it.
    # Since the package is unsupported, upstream changes are unlikely to occur.
    # Install the library and headers manually for now.
    lib.install "uulib/libuu.a"
    include.install "uulib/uudeview.h"
  end

  test do
    system "#{bin}/uudeview", "-V"
  end
end
