require 'formula'

class Cvs2svn < Formula
  url 'http://trac.macports.org/export/70472/distfiles/cvs2svn/cvs2svn-2.3.0.tar.gz'
  homepage 'http://cvs2svn.tigris.org/'
  md5 '6c412baec974f3ff64b9145944682a15'

  def install
    unless quiet_system "/usr/bin/env", "python", "-c", "import gdbm"
      onoe "The Python being used doesn't have gdbm support:"
      puts `which python`
      puts "The Homebrew-built Python does include gdbm support, which"
      puts "is required for this formula."
      exit 1
    end

    system "python", "setup.py", "install", "--prefix=#{prefix}"
    system "make man"
    man1.install gzip('cvs2svn.1', 'cvs2git.1', 'cvs2bzr.1')
    prefix.install %w[ BUGS CHANGES COMMITTERS HACKING
      cvs2bzr-example.options cvs2git-example.options cvs2hg-example.options
      cvs2svn-example.options contrib ]

    doc.install Dir['doc/*']
    doc.install Dir['www/*']
  end

  def caveats; <<-EOF
    NOTE: man pages have been installed, but for better documentation see:
      #{HOMEBREW_PREFIX}/share/doc/cvs2svn/cvs2svn.html
    or http://cvs2svn.tigris.org/cvs2svn.html.

    Contrib scripts and example options files are installed in:
      #{prefix}
    EOF
  end
end
