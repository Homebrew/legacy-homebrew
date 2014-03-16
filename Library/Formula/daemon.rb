require 'formula'

class Daemon < Formula
  homepage 'http://libslack.org/daemon/'
  url 'http://libslack.org/daemon/download/daemon-0.6.4.tar.gz'
  sha1 'fa6298f05f868d54660a7ed70c05fb7a0963a24b'

  def patches
    # fixes for mavericks strlcpy/strlcat: https://trac.macports.org/ticket/42845
    {:p1 => "https://trac.macports.org/raw-attachment/ticket/42845/daemon-0.6.4-ignore-strlcpy-strlcat.patch"} if MacOS.version == :mavericks
  end

  def install
    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
