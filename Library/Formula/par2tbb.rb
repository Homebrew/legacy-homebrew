require 'formula'

# Conflicts with the par2 formula, but there's no way to signal that

class Par2tbb < Formula
  url 'http://chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203.tar.gz'
  homepage 'http://chuchusoft.com/par2_tbb/'
  md5 'b1052a08c3c6eac8a7a0605addb161e7'

  depends_on 'tbb'

  def install
    # tbb is only built on x86_64 mode on Lion;
    # therefore par2tbb needs to be 64bit too
    # CC/CXX are llvm-gcc/++ because tbb also is built with them

    # par2tbb ships with bad timestamps and
    # doesn't respect --disable-maintainer-mode

    # it ships with broken permissions too
    FileUtils.chmod 0755, 'install-sh'

    # par2tbb expects to link against 10.4 / 10.5 SDKs,
    # but only 10.6+ are available on Xcode4
    # sed is done against the .am file since .in will be regenerated anyway
    system "/usr/bin/sed -i '' /-mmacosx-version/d Makefile.am"

    # NOTE: fails build with clang; doesn't recognize a x87 instruction
    #       works with llvm-g++ though.

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "CC=llvm-gcc", "CXX=llvm-g++",
                          "--host=x86_64-apple-darwin11"
    system "make install"
  end

  def test
    system "par2"
  end
end
