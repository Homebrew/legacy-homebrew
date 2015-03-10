require "formula"

class Re2c < Formula
  homepage "http://re2c.org"
  url "https://downloads.sourceforge.net/project/re2c/re2c/0.14.1/re2c-0.14.1.tar.gz"
  sha1 "b6af07ed6b57ef20936555c95ffb9f177aae3c28"

  bottle do
    cellar :any
    sha256 "22b82ae03ac1c69932ca72260b479469a30ed24bdee7536d797dd95e2b369da4" => :yosemite
    sha256 "8c6ea2d5466a87211b33d8be156ffeb97aa9cfa1c9a5fa9c9fa21b8a7e436629" => :mavericks
    sha256 "1a167fbc6d08ef5a9ddf483d0661036529865c7dc594395d321428e3c1185a06" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
