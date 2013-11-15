require 'formula'

class Ficy < Formula
  homepage 'http://www.thregr.org/~wavexx/software/fIcy/index.html'
  url 'http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.18.tar.gz'
  sha1 '326d1b5417e9507974df94d227c7e7e476b7598f'

  def install
    system "make"
    system "mkdir -p #{prefix}"
    system "cp fIcy #{prefix}/fIcy" 
    system "ln -s #{prefix}/fIcy /usr/local/bin/fIcy" 
    system "cp fPls #{prefix}/fPls" 
    system "ln -s #{prefix}/fPls /usr/local/bin/fPls" 
    system "cp fResync #{prefix}/fResync" 
    system "ln -s #{prefix}/fResync /usr/local/bin/fResync" 
  end

  test do
    system "fIcy"
    system "fPls"
    system "fResync"
  end
end
