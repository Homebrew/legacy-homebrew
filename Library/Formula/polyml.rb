require 'formula'

class Polyml < Formula
  url 'http://downloads.sourceforge.net/project/polyml/polyml/5.3/polyml.5.3.tar.gz'
  homepage 'http://www.polyml.org'
  md5 'c4e3a33307c4465c4f068ae4fa225ced'

  # Or dynamic linking breaks
  skip_clean :all

  def install
    # for whatever reason, the configure script fails to find c++ if CXX is defined.
    # this overrides configure so that it won't check for c++ and will assume it exists.
    ENV["check_cpp"] = "yes"
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
