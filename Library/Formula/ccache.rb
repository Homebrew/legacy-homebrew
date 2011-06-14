require 'formula'

class Ccache < Formula
  url 'http://samba.org/ftp/ccache/ccache-3.1.4.tar.bz2'
  homepage 'http://ccache.samba.org/'
  md5 '676fda8a9a5e02574435c32b22942abd'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"

    # Install symlinks for a variety of compilers into
    # #{libexec}/ccache.  Prepending this directory to your
    # PATH should automatically activate ccache for most compiles.

    ohai "Creating symbolic links"

    libexec.mkpath

    %w[
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0 gcc-4.2
      c++ c++3 c++-3.3 c++-4.0 c++-4.2
      g++ g++2 g++3 g++-3.3 g++-4.0 g++-4.2
    ].each do |prog|
      ln_s bin+"ccache", libexec + prog
    end
  end

  def caveats
    <<-EOS
      To install symlinks for compilers that will automatically use
      ccache, add this folder to the front of your PATH:
        #{libexec}

      If this is an upgrade and you have previously added the symlinks to
      your PATH, you will need to modify it to the path specified above so
      it points to the new version.

      NOTE: ccache can prevent some software from compiling.
    EOS
  end
end
