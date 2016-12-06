require 'formula'

class PerconaToolkit < Formula
  url 'http://www.percona.com/redir/downloads/percona-toolkit/percona-toolkit-1.0.1.tar.gz'
  homepage 'http://www.percona.com/software/percona-toolkit/'
  md5 '1d843b1b3ebd2eacfa3bf95ef2a00557'

  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make install"
  end
end
