class Libosxnotify < Formula
  desc "No nonsense OS X notifications for scripts"
  homepage "https://tomekwojcik.github.io/libosxnotify/"
  url "https://github.com/tomekwojcik/libosxnotify/archive/v1.0.tar.gz"
  sha256 "c2bc42057f74fac9a267c00c0d0098682ad9922e8883f3efdf24757b6fd6473d"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    bin.install "build/osxnotify"
    include.install "build/libosxnotify.h"
    lib.install "build/libosxnotify.dylib"
    prefix.install "LICENSE"
    prefix.install "README.md"
  end

  test do
    system "#{bin}/osxnotify"
    # Exit status 64 indicates "no args".
    return $?.exitstatus == 64
  end
end
