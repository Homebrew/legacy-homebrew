class Streamripper < Formula
  desc "Separate tracks via Shoutcasts title-streaming"
  homepage "http://streamripper.sourceforge.net/"
  url "https://downloads.sourceforge.net/sourceforge/streamripper/streamripper-1.64.6.tar.gz"
  sha256 "c1d75f2e9c7b38fd4695be66eff4533395248132f3cc61f375196403c4d8de42"

  depends_on "pkg-config" => :build
  depends_on "glib"

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
    system "make", "install"
  end
end
