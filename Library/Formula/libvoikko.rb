require 'formula'

class Libvoikko < Formula
  homepage 'http://voikko.puimula.org/'
  url 'http://www.puimula.org/voikko-sources/libvoikko/libvoikko-3.7.tar.gz'
  sha1 '27ad3f72316d3878a0ed7b94a9e855bff66cb81b'

  depends_on 'pkg-config' => :build
  depends_on 'suomi-malaga-voikko'

  # Fixes compilation issues on OS X 10.9. Both merged upstream:
  # https://github.com/voikko/corevoikko/pull/5
  # https://github.com/voikko/corevoikko/pull/6
  # Note that the upstream commits don't apply cleanly to stable
  patch do
    url "https://gist.githubusercontent.com/osimola/7724611/raw/2dcfddaf4bf7c7e9d940edb1b982d5b5e39bc378/libvoikko-3.7-mavericks.patch"
    sha1 "532d0a3097569c966b2632a5b876d9082b4a2c49"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"
  end
end
