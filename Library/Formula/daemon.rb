require 'formula'

class Daemon < Formula
  homepage 'http://libslack.org/daemon/'
  url 'http://libslack.org/daemon/download/daemon-0.6.4.tar.gz'
  sha1 'fa6298f05f868d54660a7ed70c05fb7a0963a24b'

  # fixes for mavericks strlcpy/strlcat: https://trac.macports.org/ticket/42845
  patch do
    url "https://trac.macports.org/raw-attachment/ticket/42845/daemon-0.6.4-ignore-strlcpy-strlcat.patch"
    sha1 "8330e7a2df1b8a37b440709c26baf55df251bc56"
  end if MacOS.version == :mavericks

  def install
    system "./config"
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/daemon", "--version"
  end
end
