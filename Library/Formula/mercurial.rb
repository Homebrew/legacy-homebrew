require 'formula'

class Mercurial < Formula
  homepage 'http://mercurial.selenic.com/'
  url 'http://mercurial.selenic.com/release/mercurial-2.6.1.tar.gz'
  sha1 'ee9b2ae1cf2518c90b55f9429bf4ed9f2d4fced6'

  head 'http://selenic.com/repo/hg', :using => :hg

  depends_on :python # its written in Python, so this is a hard dep
  depends_on 'docutils' => :python if build.head? or build.include? 'doc'

  option 'doc', "Build the documentation"

  def install
    # Don't add compiler specific flags so we can build against
    # System-provided Python.
    ENV.minimal_optimization

    # install the completion script
    bash_completion.install 'contrib/bash_completion' => 'hg-completion.bash'

    python do
      system "make doc" if build.head? or build.include? 'doc'
      system "make local"

      libexec.install 'hg', 'mercurial', 'hgext'
      # If we get it working with python3, we would need the next line instead:
      #['hg', 'mercurial', 'hgext'].each{ |f| libexec.install "#{f}#{python.if3then3}" }

      # Symlink the hg binary into bin
      bin.install_symlink libexec/"hg#{python.if3then3}"

      # Install some contribs
      bin.install "contrib/hgk#{python.if3then3}"
      # Install man pages
      man1.install 'doc/hg.1'
      man5.install 'doc/hgignore.5', 'doc/hgrc.5'

      system 'make clean'
    end

  end

  def caveats
    s = ''

    s += <<-EOS.undent
      Extensions have been installed to:
        #{opt_prefix}/libexec/hgext
    EOS

    if build.head? then s += <<-EOS.undent

      Mercurial is required to fetch its own repository, so there are now two
      installations of mercurial on this machine. If the previous installation
      was done via Homebrew, the old version may need to be cleaned up and new
      version linked:

        brew cleanup mercurial && brew link mercurial
      EOS
    end

    return s
  end

  def test
    system "#{bin}/hg", "debuginstall"
  end
end
