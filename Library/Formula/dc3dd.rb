class Dc3dd < Formula
  desc "Patched GNU dd that is intended for forensic acquisition of data"
  homepage "http://sourceforge.net/projects/dc3dd/"
  url "https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.1.0/dc3dd-7.1.614.tar.gz"
  sha256 "f6fb4d921928e6354e9f8ff2a8415ebc42b129959996e1ab0d10899c11aac198"

  def install
    args = %W[--disable-debug
              --disable-dependency-tracking
              --prefix=#{prefix}
              --infodir=#{info}]

    # Check for stpncpy is broken, and the replacement fails to compile
    # on Lion and newer; see https://github.com/Homebrew/homebrew/issues/21510
    args << "gl_cv_func_stpncpy=yes" if MacOS.version >= :lion
    system "./configure", *args
    system "make"
    system "make", "install"
    prefix.install %w[Options_Reference.txt Sample_Commands.txt]
  end
end
