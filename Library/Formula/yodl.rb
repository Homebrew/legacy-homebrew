require "formula"

class Yodl < Formula
  homepage "http://yodl.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/yodl/yodl/3.03.0/yodl_3.03.0.orig.tar.gz"
  sha1 "bf244ab9b14024db98bee417c2055196237fab0b"
  version "3.03.0"

  option 'with-manual', "Use latex to create an optional manual during build."
  
  depends_on "icmake" => :build
  depends_on :tex => 'with-manual'

  def patches
    'https://gist.github.com/FloFra/8485659/raw'
  end

  def install
    inreplace 'INSTALL.im', %-"/usr"-, %-"#{prefix}"-
    inreplace 'build', '#!/usr/bin/icmake', '#!/usr/bin/env icmake' 

    # Build all
    system "./build programs"
    system "./build man"

    if build.with? 'manual'
      system "./build manual"
    end

    system "./build macros"

    # Install all
    system "./build install programs /"
    system "./build install man /"

    if build.with? 'manual'
      system "./build install manual /"
    end

    system "./build install macros /"
    system "./build install docs /"
  end
end

