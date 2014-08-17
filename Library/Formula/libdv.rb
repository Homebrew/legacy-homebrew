require 'formula'

class Libdv < Formula
  homepage 'http://libdv.sourceforge.net'
  url 'https://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz'
  sha1 '2e5ba0e95f665d60e72cbebcf1c4989e0d6c92c8'

  bottle do
    cellar :any
    sha1 "0ab33938816dfcef7dce110e2cea98519eb5a958" => :mavericks
    sha1 "5a7346e4b2871f55c1823dab7620a88d5e3e2f69" => :mountain_lion
    sha1 "851394c94147765570f9d06825f28af081e9fbfb" => :lion
  end

  depends_on 'popt'

  def install
    # This fixes an undefined symbol error on compile.
    # See the port file for libdv. http://libdv.darwinports.com/
    # This flag is the preferred method over what macports uses.
    # See the apple docs: http://cl.ly/2HeF bottom of the "Finding Imported Symbols" section
    ENV.append "LDFLAGS", "-undefined dynamic_lookup"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtktest",
                          "--disable-gtk",
                          "--disable-asm",
                          "--disable-sdltest"
    system "make install"
  end
end
