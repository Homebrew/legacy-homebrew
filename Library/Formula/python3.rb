# Lightly modified from the Python 2.6.5 formula.
require 'formula'

class Python3 <Formula
  url 'http://www.python.org/ftp/python/3.1.2/Python-3.1.2.tar.bz2'
  homepage 'http://www.python.org/'
  md5 '45350b51b58a46b029fb06c61257e350'

  depends_on 'readline' => :optional  # Prefer over OS X's libedit.
  depends_on 'sqlite' => :optional  # Prefer over OS X's copy.
  depends_on 'gdbm' => :optional
  # With all dependencies installed should only have ossaudiodev and spwd not
  # built from the stdlib.

  def options
    [
      ["--framework", "Do a 'Framework' build instead of a UNIX-style build."],
      ["--universal", "Build for both 32 & 64 bit Intel."]
    ]
  end

  # XXX Overriding skip_clean? is deprecated
  def skip_clean? path
    # Need to keep the versioned binaries.
    # Also, don't strip out pre-compiled # bytecode files.
    path == bin+'python3' or path == bin+'python3.1' or
    path == lib+'python3.1'
  end

  def install
    # --with-computed-gotos requires addressable labels in C;
    # both gcc and LLVM support this, so switch it on.
    args = ["--prefix=#{prefix}", "--with-computed-gotos"]

    args << "--enable-framework" if ARGV.include? '--framework'
    if ARGV.include? '--universal'
      args.push "--enable-universalsdk=/", "--with-universal-archs=intel"
    end
    
    system "./configure", *args
    system "make"
    system "make install"
  end
end
