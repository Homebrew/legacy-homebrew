require 'formula'

class Polyml < Formula
  homepage 'http://www.polyml.org'
  url 'http://downloads.sourceforge.net/project/polyml/polyml/5.5/polyml.5.5.tar.gz'
  sha1 '9b308d3ac69316d1fcb0f6ac5f9b9e2d2390d511'

  def install
    # for whatever reason, the configure script fails to find c++ if CXX is defined.
    # this overrides configure so that it won't check for c++ and will assume it exists.
    ENV["check_cpp"] = "yes"
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
