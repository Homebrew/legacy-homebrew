require "formula"

class Libpng < Formula
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sf.net/project/libpng/libpng16/1.6.13/libpng-1.6.13.tar.xz"
  sha1 "5ae32b6b99cef6c5c85feab8edf9d619e1773b15"

  bottle do
    cellar :any
    sha1 "c4c5f94b771ea53620d9b6c508b382b3a40d6c80" => :yosemite
    sha1 "09af92d209c67dd0719d16866dc26c05bbbef77b" => :mavericks
    sha1 "23812e76bf0e3f98603c6d22ab69258b219918ca" => :mountain_lion
    sha1 "af1fe6844a0614652bbc9b60fd84c57e24da93ee" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
