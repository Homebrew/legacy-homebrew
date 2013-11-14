require 'formula'

<<<<<<< HEAD
class Ficy < Formula
  homepage 'http://www.thregr.org/~wavexx/software/fIcy/'
  url 'http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.18.tar.gz'
  sha1 '326d1b5417e9507974df94d227c7e7e476b7598f'

  def install
    system "make"
    bin.install 'fIcy', 'fPls', 'fResync'
=======
# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ficy < Formula
  homepage 'http://www.thregr.org/~wavexx/software/fIcy/index.html'
  url 'http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.18.tar.gz'
  sha1 '326d1b5417e9507974df94d227c7e7e476b7598f'

  depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "mkdir -p #{prefix}"
    # if this fails, try separate make/make install steps
    system "cp fIcy #{prefix}/fIcy" 
    system "ln -s #{prefix}/fIcy /usr/local/bin/fIcy" 
    system "cp fPls #{prefix}/fPls" 
    system "ln -s #{prefix}/fPls /usr/local/bin/fPls" 
    system "cp fResync #{prefix}/fResync" 
    system "ln -s #{prefix}/fResync /usr/local/bin/fResync" 
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test fIcy`.
    system "fIcy"
    system "fPls"
    system "fResync"
>>>>>>> konquis-version
  end
end
