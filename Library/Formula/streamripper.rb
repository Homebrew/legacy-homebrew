require 'formula'

class Streamripper < Formula
  homepage 'http://streamripper.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/streamripper/streamripper-1.64.6.tar.gz'
  sha1 'bc8a8d3ad045e0772ca691d2063c39efcc0dca45'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  fails_with :llvm do
    build 2335
    cause "Strange runtime errors with LLVM."
  end

  def install
    # the Makefile ignores CPPFLAGS from the environment, which
    # breaks the build when HOMEBREW_PREFIX is not /usr/local
    ENV.append_to_cflags ENV.cppflags

    chmod 0755, "./install-sh" # or "make install" fails

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
