require 'formula'

class Streamripper < Formula
  homepage 'http://streamripper.sourceforge.net/'
  url 'http://downloads.sourceforge.net/sourceforge/streamripper/streamripper-1.64.6.tar.gz'
  md5 'a37a1a8b8f9228522196a122a1c2dd32'

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
