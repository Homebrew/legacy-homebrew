require 'formula'

class Ccache <Formula
  url 'http://samba.org/ftp/ccache/ccache-2.4.tar.gz'
  homepage 'http://ccache.samba.org/'
  md5 '73c1ed1e767c1752dd0f548ec1e66ce7'

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
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0
      c++ c++3 c++-3.3 c++-4.0
      g++ g++2 g++3 g++-3.3 g++-4.0
    ].each do |prog|
      ln_s bin+"ccache", libexec + prog
    end
  end

  def caveats
    <<-EOS
      To install symlinks for compilers that will automatically use
      ccache, add this folder to the front of your PATH:
        #{libexec}

      NOTE: ccache can prevent some software from compiling.
    EOS
  end
end
