class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "http://opencore-amr.sourceforge.net/"
  url "https://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.3.tar.gz"
  sha256 "106bf811c1f36444d7671d8fd2589f8b2e0cca58a2c764da62ffc4a070595385"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
