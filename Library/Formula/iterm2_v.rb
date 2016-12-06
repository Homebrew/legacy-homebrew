require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Iterm2V < Formula
  homepage 'http://www.iterm2.com/'
  version '1.0.0'
  url 'http://iterm2.googlecode.com/files/iTerm2-1_0_0_20120726.zip'
  sha1 '19538b6be5cb6f97e34aa729983a90ebc7a0e7ea'

  # depends_on 'cmake' => :build
  # depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
	prefix.install "iTerm.app"
  end

  def caveats; <<-EOS.undent
    iTerm.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/iTerm.app /Applications
    EOS
  end
end
