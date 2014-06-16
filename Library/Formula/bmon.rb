require 'formula'

class Bmon < Formula
  homepage 'http://www.carisma.slowglass.com/%7Etgr/bmon/'
  url 'http://www.carisma.slowglass.com/~tgr/bmon/files/bmon-3.1.tar.gz'
  sha1 'f47ab2249f605bcd0bc50d912f3aca35d65819c9'

  depends_on "confuse"
  depends_on "pkg-config" => :build

  # Patch for Remove the dependence on libnl
  patch do
    url "https://gist.githubusercontent.com/gaoyifan/916be1f0191e1ef10058/raw/799d5828edb5240179a57efd7dce6937a917db36/bmon-3.1-patch.diff"
    sha1 "8af2037342d5da12aa44ab346419911c835005a1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make" # two steps to prevent blowing up
    system "make install"
  end
end
