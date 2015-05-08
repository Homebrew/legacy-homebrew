require "formula"

class Mg3a < Formula
  homepage "http://www.bengtl.net/files/mg3a/"
  # url "http://www.bengtl.net/files/mg3a/mg3a.150427.tar.gz"
  # sha256 "d18abb1d8c5d32a72de2c7eea1860974b97e02a0a66dc9a81c3920805c7f3d64"
  url "http://www.bengtl.net/files/mg3a/snapshots/mg3a.150506.tar.gz"
  sha256 "988873190544b17e9d90bcc4101156c044a10ea1e256424a59702986c92ca4e4"

  option "without-emacs-quit", "Use ^U ^X ^C to exit saving"
  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "without-dired", "Exclude dired functions"
  option "without-prefix-region", "Exclude the prefix region mode"
  option "with-user-modes", "Include the support for user defined modes"
  option "with-user-macros", "Include the support for user defined macros"
  option "with-most","Include c-like and python modes, user modes and user macros"
  option "with-all","Include all fancy stuff"
  
  # currently, Bengt's makefile doesn't allow to customize
  # the supported modes while making mg. We need a small patch for that
  # should be removed when that is fixed
  
  def install
    mg3aopts=""
    mg3aopts << " -DDIRED" if build.with? 'dired' or build.with? 'most'
    mg3aopts << " -DPREFIXREGION" if build.with? 'prefix-region' or build.with? 'most'
    mg3aopts << " -DLANGMODE_C" if build.with? 'c-mode'
    mg3aopts << " -DLANGMODE_PYTHON" if build.with? 'python-mode' or build.with? 'most'
    mg3aopts << " -DLANGMODE_CLIKE" if build.with? 'clike-mode' or build.with? 'most'
    mg3aopts << " -DUSER_MODES" if build.with? 'user-modes' or build.with? 'most'
    mg3aopts << " -DUSER_MACROS" if build.with? 'user-macros' or build.with? 'most'
    mg3aopts = "-DALL" if build.with? 'all'
    mg3aopts << " -DEMACS_QUIT" if build.with? 'emacs-quit'
    
    system "make clean; make CDEFS=\"#{mg3aopts}\" LIBS=-lncurses COPT=-O3"
    bin.install "mg"
    doc.install Dir['bl/dot.*']
    doc.install Dir['README*']
  end
  
  test do
    system "false"
  end
end
