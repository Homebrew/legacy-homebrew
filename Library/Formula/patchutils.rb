class Patchutils < Formula
  homepage "http://cyberelk.net/tim/software/patchutils/"
  url "http://cyberelk.net/tim/data/patchutils/stable/patchutils-0.3.3.tar.xz"
  sha1 "89d3f8a454bacede1b9a112b3a13701ed876fcc1"

  bottle do
    cellar :any
    sha1 "e339d44549d5adaf0907752d87a15c74fdc14892" => :yosemite
    sha1 "1d2ef386ca2d3f17574ecdb8ca2cf3dbde142296" => :mavericks
    sha1 "56c838384a5712786d2a424a57ce69b168e1f66e" => :mountain_lion
  end

  # Fix 'filterdiff --exclude-from-file...' crashes
  # https://fedorahosted.org/patchutils/ticket/30
  patch do
    url "https://fedorahosted.org/patchutils/raw-attachment/ticket/30/0001-Provide-NULL-pointer-to-getline-to-avoid-realloc-ing.patch"
    sha1 "e787c8df1501feea5c895cdf9e8e01441035bdcf"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /a\/libexec\/NOOP/,
          shell_output("#{bin}/lsdiff #{HOMEBREW_LIBRARY.join("Homebrew", "test", "patches", "noop-a.diff")}")
  end
end
