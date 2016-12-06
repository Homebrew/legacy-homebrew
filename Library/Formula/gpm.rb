require 'formula'

class Gpm < Formula
  homepage 'https://github.com/pote/gpm'
  url 'https://github.com/pote/gpm/archive/v0.4.0.tar.gz'
  sha1 'afb3761c9ca7e43c42bbcbe0040a01a9bd6d9b36'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "gpm"
  end
end
