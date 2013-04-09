require 'formula'

class Bfgminer < Formula
  homepage 'https://github.com/luke-jr/bfgminer'
  url 'http://luke.dashjr.org/programs/bitcoin/files/bfgminer/3.0.0/bfgminer-3.0.0.tbz2'
  head 'https://github.com/luke-jr/bfgminer.git', :using => :git
  sha256 '86f7f977ed57b8d61c728f88a3e5962aa1df0723d667c45b1e1bfa5152292400'

  option 'with-scrypt', 'Build with scrypt support'

  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'jansson'
  depends_on 'curl'

  depends_on 'libusb' => :optional
  option 'with-libusb', 'Build with libusb (for ZTEX/X6500 FPGAs) support'

  if build.head?
    depends_on :autoconf
    depends_on :automake
  end

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--with-scrypt" if build.include? 'with-scrypt'

    system "./configure", *args
    system "make install"
  end

end
