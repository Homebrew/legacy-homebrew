require "formula"

class FdkAac < Formula
  homepage "http://sourceforge.net/projects/opencore-amr/"
  url "https://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-0.1.3.tar.gz"
  sha1 "fda64beee7f3b8e04ca209efcf9354cdae9afc33"

  head do
    url "git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/fdk-aac"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
