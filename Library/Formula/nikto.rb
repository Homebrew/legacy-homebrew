require "formula"

class Nikto < Formula
  homepage 'http://cirt.net/nikto2'
  url "https://www.cirt.net/nikto/nikto-2.1.5.tar.bz2"
  sha1 "9fafa51f630ce241aff58b217882e514d577939f"

  def install
    # adjust default paths in perl script
    inreplace 'nikto.pl' do |s|
      s.gsub! '/etc/nikto.conf', "#{etc}/nikto.conf"
    end

    # adjust default paths in configuration file
    inreplace 'nikto.conf' do |s|
      s.gsub! '# EXECDIR=/opt/nikto', "EXECDIR=#{prefix}"
      s.gsub! '# PLUGINDIR=/opt/nikto/plugins', "PLUGINDIR=#{prefix}/plugins"
      s.gsub! '# DBDIR=/opt/nikto/databases', "DBDIR=#{var}/lib/nikto/databases"
      s.gsub! '# TEMPLATEDIR=/opt/nikto/templates', "TEMPLATEDIR=#{prefix}/templates"
      s.gsub! '# DOCDIR=/opt/nikto/docs', "DOCDIR=#{prefix}/docs"
    end

    bin.install 'nikto.pl'                              # install main perl script
    bin.install_symlink bin + 'nikto.pl' => 'nikto'     # symlink w/o extension
    etc.install 'nikto.conf'                            # install conf file
    man1.install 'docs/nikto.1'                         # install man page
    (prefix + 'docs').install Dir['docs/*']             # miscellaneous
    prefix.install 'plugins', 'templates'               # install plugins, templates
    (var+'lib/nikto/databases').mkpath                  # make dir for databases
  end

  def caveats;  <<-EOS.undent
    File locations:
    Perl script:    #{HOMEBREW_PREFIX}/bin/nikto
    Configuration:  #{etc}/nikto.conf
    Docs:           #{prefix}/docs
    Plugins:        #{prefix}/plugins
    Databases:      #{var}/lib/nikto/databases
    Templates:      #{prefix}/templates

    Type `man nikto` or `nikto -H` for help and usage information.
    Don't forget to `nikto -update` before your first run.
    EOS
  end

  # run the test with `brew test nikto`
  def test
    system "test -h #{bin}/nikto"           # symlink?
    system "test -x #{bin}/nikto.pl"        # execute permission?
    system "test -f #{etc}/nikto.conf"      # file?
    system "test -f #{man1}/nikto.1"        # file?
    system "test -d #{prefix}/docs"         # directory?
    system "test -d #{prefix}/plugins"      # directory?
    system "test -d #{prefix}/templates"    # directory?
  end
end
