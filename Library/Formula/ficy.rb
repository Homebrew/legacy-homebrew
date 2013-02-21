require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ficy < Formula
  homepage 'http://www.thregr.org/~wavexx/software/fIcy/'
  url 'http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.18.tar.gz'
  sha1 '326d1b5417e9507974df94d227c7e7e476b7598f'

  depends_on 'cmake' => :build

  def install
    system "make"
    system "cp fIcy fPls fResync #{prefix}"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test fIcy`.
    system "fIcy"
    system "fPls"
    system "fResync"
  end
end
