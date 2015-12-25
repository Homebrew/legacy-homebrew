class Libdca < Formula
  desc "Library for decoding DTS Coherent Acoustics streams"
  homepage "https://www.videolan.org/developers/libdca.html"
  url "https://download.videolan.org/pub/videolan/libdca/0.0.5/libdca-0.0.5.tar.bz2"
  sha256 "dba022e022109a5bacbe122d50917769ff27b64a7bba104bd38ced8de8510642"

  bottle do
    sha256 "8b54e4bd1b265632e25711377eaf6737e48ff03d965cd76ffddc07fb76528bef" => :yosemite
    sha256 "e7635c2ab807e636e2942840d1c8f56db69205c18649b97e4f835312d8333513" => :mavericks
    sha256 "457848ef40ba06b2c422e090c5bb7c0a02008e86cee0b0c7e8ae35e36d5b83c0" => :mountain_lion
  end

  def install
    # Fixes "duplicate symbol ___sputc" error when building with clang
    # https://github.com/Homebrew/homebrew/issues/31456
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
