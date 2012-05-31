require 'formula'

class SoundTouch < Formula
  url 'http://www.surina.net/soundtouch/soundtouch-1.5.0.tar.gz'
  homepage 'http://www.surina.net/soundtouch/'
  md5 '5456481d8707d2a2c27466ea64a099cb'

  depends_on 'autoconf' => :build unless MacOS.xcode_version.to_f >= 4.3

  def install
    # SoundTouch has a small amount of inline assembly. The assembly has two labeled
    # jumps. When compiling with gcc optimizations the inline assembly is duplicated
    # and the symbol label occurs twice causing the build to fail.
    ENV.no_optimization
    # 64bit causes soundstretch to segfault when ever it is run.
    ENV.m32

    # The build fails complaining about out of date libtools. Rerunning the autoconf prevents the error.
    system "autoconf"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
