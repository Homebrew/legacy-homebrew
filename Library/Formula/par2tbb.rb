require 'formula'

class Par2tbb < Formula
  url 'http://chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203.tar.gz'
  homepage 'http://chuchusoft.com/par2_tbb/'
  md5 'b1052a08c3c6eac8a7a0605addb161e7'

  depends_on 'tbb'

  fails_with :clang do
    build 318
  end

  def install
    # par2tbb ships with bad timestamps and
    # doesn't respect --disable-maintainer-mode
    # it ships with broken permissions too
    chmod 0755, 'install-sh'

    # par2tbb expects to link against 10.4 / 10.5 SDKs,
    # but only 10.6+ are available on Xcode4
    inreplace 'Makefile.am', /^.*-mmacosx-version.*$/, ''

    if Formula.factory('par2').installed?
      opoo "par2tbb conflicts with par2. Your par2 binaries will be overwritten.
         If this bothers you, you can restore par2 with `brew link par2`."
    end

    host_triplet = MacOS.prefer_64_bit? ? "x86_64-apple-darwin11" : "i686-apple-darwin11"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--build=#{host_triplet}",
                          "--host=#{host_triplet}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
    par2tbb is a modified fork of par2 and conflicts with its binaries.
    EOS
  end

  def test
    system "#{bin}/par2"
  end
end
