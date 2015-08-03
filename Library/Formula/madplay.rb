class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "http://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"

  depends_on "mad"
  depends_on "libid3tag"

  patch :p0 do
    url "https://trac.macports.org/export/89276/trunk/dports/audio/madplay/files/patch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]
    # Avoid "error: CPU you selected does not support x86-64 instruction set"
    args << "--build=#{Hardware::CPU.arch_64_bit}" if MacOS.prefer_64_bit?
    system "./configure", *args
    system "make", "install"
  end
end
