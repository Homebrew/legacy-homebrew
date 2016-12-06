require 'formula'

class Wxpython < Formula
  url 'http://downloads.sourceforge.net/wxpython/wxPython-src-2.9.1.1.tar.bz2'
  homepage 'http://www.wxpython.org/'
  md5 'f7ef8d0f68b514e17da40f957f48ca4e'

  def patches
    # see here: http://trac.wxwidgets.org/ticket/13030
    { :p3 => "http://trac.wxwidgets.org/changeset/67170?format=diff&new=67170" }
  end

  def install
    # Arch change from winpdb commit at https://github.com/mxcl/homebrew/pull/5772
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    ENV['ARCHFLAGS'] = archs.as_arch_flags

    cd "wxPython"
    system "python", "build-wxpython.py",
           "--osx_cocoa", "--mac_framework", "--prefix=#{prefix}", "--install"
  end
end


