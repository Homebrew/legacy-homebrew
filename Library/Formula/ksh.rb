require "formula"

class KshDownloadStrategy < NoUnzipCurlDownloadStrategy
  # AT&T requires the following credentials to "assent" to the OSS license.
  def credentials
    "I.accept.www.opensource.org.licenses.eclipse:."
  end

  def curl(*args)
    args << "-u" << credentials
    super
  end
end

class Ksh < Formula
  homepage "http://www.kornshell.com"
  url  "http://www2.research.att.com/~astopen/download/tgz/ast-ksh.2012-08-01.tgz",
    :using => KshDownloadStrategy
  sha1 "316428e9937806183a134aa1669dea40c3a73695"
  version "93u+" # Versioning scheme: + means "+ patches", - means "beta/alpha".

  bottle do
    cellar :any
    revision 1
    sha1 "e9cb13e19571b48d13c1b51c37d74c8a3206d397" => :mavericks
    sha1 "568d10076fcb5b145611fd60fa01b0b0fb9d5f39" => :mountain_lion
    sha1 "ad1c9d854e90b29baee3b1ade2c185ac48119657" => :lion
  end

  resource "init" do
    url "http://www2.research.att.com/~astopen/download/tgz/INIT.2012-08-01.tgz",
      :using => KshDownloadStrategy
    sha1 "0b472a615db384fe707042baaa3347dc1aa1c81e"
  end

  def install
    (buildpath/"lib/package/tgz").install resource("init"), Dir["*.tgz"]

    system "tar", "xzf", "lib/package/tgz/INIT.2012-08-01.tgz"
    system "/bin/ksh", "bin/package", "read"

    # Needed due to unusal build system.
    ENV.refurbish_args

    # From Apple"s ksh makefile.
    kshcppdefines = "-DSHOPT_SPAWN=0 -D_ast_int8_t=int64_t -D_lib_memccpy"
    system "/bin/ksh", "bin/package", "make", "CCFLAGS=#{kshcppdefines}"

    bin.install "arch/darwin.i386-64/bin/ksh" => "ksh93"
    bin.install_symlink "ksh93" => "ksh"

    man1.install "arch/darwin.i386-64/man/man1/sh.1" => "ksh93.1"
    man1.install_symlink "ksh93.1" => "ksh.1"
  end

  def caveats; <<-EOS.undent
    We have agreed to the Eclipse Public License on your behalf.
    If this is unacceptable for any reason, please uninstall.
    EOS
  end
end
