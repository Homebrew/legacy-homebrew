class Dtach < Formula
  desc "Emulates the detach feature of screen"
  homepage "http://dtach.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dtach/dtach/0.8/dtach-0.8.tar.gz"
  sha256 "16614ebddf8ab2811d3dc0e7f329c7de88929ac6a9632d4cb4aef7fe11b8f2a9"

  def install
    # Includes <config.h> instead of "config.h", so "." needs to be in the include path.
    ENV.append "CFLAGS", "-I."

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    bin.install "dtach"
    man1.install gzip("dtach.1")
  end
end
