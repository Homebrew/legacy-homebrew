require "formula"

class CmuSphinxbase < Formula
  desc "Lightweight speech recognition engine for mobile devices"
  homepage "http://cmusphinx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cmusphinx/sphinxbase/0.8/sphinxbase-0.8.tar.gz"
  sha1 "c0c4d52e143d07cd593bd6bcaeb92b9a8a5a8c8e"

  head do
    url "https://github.com/cmusphinx/sphinxbase.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "swig" => :build
  end

  depends_on "pkg-config" => :build
  # If these are found, they will be linked against and there is no configure
  # switch to turn them off.
  depends_on "libsndfile"
  depends_on "libsamplerate" => "with-libsndfile"

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
