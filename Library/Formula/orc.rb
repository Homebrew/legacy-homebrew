require 'formula'

class Orc < Formula
  homepage 'http://cgit.freedesktop.org/gstreamer/orc/'
  url 'http://gstreamer.freedesktop.org/src/orc/orc-0.4.22.tar.xz'
  sha1 'c50cf2f2a9a7e4ab400fd79f706e831ace1936bc'

  bottle do
    cellar :any
    sha1 "6de0850741bbf8184666d242a4ce7c927ddcbebe" => :mavericks
    sha1 "13c06e141b56b09c278682019edcb70f73c606fe" => :mountain_lion
    sha1 "c089a76d9bfdfe1f5e6e6201a228d45412385e79" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make install"
  end
end
