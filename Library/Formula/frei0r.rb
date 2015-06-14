require 'formula'

class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage 'http://frei0r.dyne.org'
  url 'https://files.dyne.org/frei0r/releases/frei0r-plugins-1.4.tar.gz'
  sha1 '7995d06c5412b14fa3b05647084ca9d7a0c84faa'

  bottle do
    cellar :any
    sha1 "dfbdc10c72316e888f6b0ecd3716d57fd7a8d1fc" => :yosemite
    sha1 "457dc6f5d0786b960715da5ee5f3e426380c34c3" => :mavericks
    sha1 "2b58483d2b4bb690b852674d3319664c91a62276" => :mountain_lion
  end

  depends_on "autoconf" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
