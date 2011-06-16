require 'formula'

class Pianobar < Formula
  url 'https://github.com/PromyLOPh/pianobar/zipball/2011.04.27'
  version '2011.04.27'
  homepage 'https://github.com/PromyLOPh/pianobar/'
  md5 '1e83f851e92792bd6e59decc4a6b3662'

  head 'https://github.com/PromyLOPh/pianobar.git'

  depends_on 'libao'
  depends_on 'mad'
  depends_on 'faad2'

  skip_clean 'bin'

  fails_with_llvm "Reports of this not compiling on Xcode 4"

  def install
    ENV.delete 'CFLAGS' # Pianobar uses c99 instead of gcc; remove our gcc flags.

    # Enable 64-bit builds if needed
    w_flag = MacOS.prefer_64_bit? ? "-W64" : ""
    # Help non-default install paths
    lib_path = HOMEBREW_PREFIX.to_s == "/usr/local" ? "" : " -I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"

    inreplace "Makefile" do |s|
      s.gsub! "-O2 -DNDEBUG", "-O2 -DNDEBUG #{w_flag} #{lib_path}"
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    # Install contrib folder too, why not.
    prefix.install Dir['contrib']
  end
end
