require "formula"

class Opencbm < Formula
  homepage "http://www.trikaliotis.net/opencbm-alpha"
  url "http://www.trikaliotis.net/Download/opencbm-0.4.99.97/opencbm-0.4.99.97.tar.bz2"
  sha1 "e0f4b6c3d134d77e3da66ce4e2e1d945fded5fb6"
  head "git://git.code.sf.net/p/opencbm/code"

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "libusb-compat"

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
    ]

    # The build is buried one directory down.
    cd "opencbm" do
      system "make", *args
      system "make", "install-all", *args
    end
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
