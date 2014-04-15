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
    sha1 "fa65a4bbcc9a9c57db96d00c64cd1e5439eba5e3" => :mavericks
    sha1 "4f46403e57e4ed2668f760d4c4dea09f321f4278" => :mountain_lion
    sha1 "973d02e45b84e79fd65e56ed46b8b813553bad79" => :lion
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
