require 'formula'
require 'qemu'

class QemuImg < Formula
  homepage Qemu.homepage
  url Qemu.url
  sha256 Qemu.sha256

  depends_on 'glib'

  def install
    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
    ]
    system "./configure", *args
    system "make qemu-img"
    bin.install "qemu-img"
  end
end
