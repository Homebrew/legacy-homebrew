require 'formula'

class Par2tbb < Formula
  homepage 'http://chuchusoft.com/par2_tbb/'
  url 'http://chuchusoft.com/par2_tbb/par2cmdline-0.4-tbb-20100203.tar.gz'
  sha1 '2fcdc932b5d7b4b1c68c4a4ca855ca913d464d2f'

  depends_on 'tbb'

  conflicts_with "par2",
    :because => "par2tbb and par2 install the same binaries."

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

    host_triplet = MacOS.prefer_64_bit? ? "x86_64-apple-darwin11" : "i686-apple-darwin11"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--build=#{host_triplet}",
                          "--host=#{host_triplet}"
    system "make install"
  end

  def test
    system "#{bin}/par2"
  end
end
