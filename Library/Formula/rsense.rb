require 'formula'

class Rsense < Formula
  homepage 'http://cx4a.org/software/rsense/'
  url 'http://cx4a.org/pub/rsense/rsense-0.3.tar.bz2'
  sha1 '497510e7048120af01bac619e50aa72ebd825c49'

  def install
    prefix.install_metafiles
    libexec.install Dir['*']
    (libexec/'bin/rsense').chmod 0755
    bin.write_exec_script libexec/'bin/rsense'
  end

  def caveats
    <<-EOS.undent
    If this is your first install, create default config file:
        ruby #{libexec}/etc/config.rb > ~/.rsense

    You will also need to setup Emacs and/or Vim to use Rsense. Please
    refer to the User Manual: http://cx4a.org/software/rsense/manual.html
    EOS
  end

  test do
    system "#{bin}/rsense", "version"
  end
end
