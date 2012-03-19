require 'formula'

class Nikto < Formula
  homepage 'http://cirt.net/nikto2'
  url 'https://cirt.net/nikto/nikto-2.1.4.tar.gz'
  md5 '8b9df0b08bbbcdf25b5ddec9e30b2633'

  def install
    # adjust default paths in perl script
    inreplace 'nikto.pl' do |s|
      s.gsub! '/etc/nikto.conf', "#{etc}/nikto.conf"
    end
    
    # adjust default paths in configuration file
    inreplace 'nikto.conf' do |s|
      s.gsub! '# EXECDIR=/usr/local/nikto', "EXECDIR=#{prefix}"
      s.gsub! '# EXECDIR=/opt/nikto', "# EXECDIR=#{prefix}"
      s.gsub! '# PLUGINDIR=/opt/nikto/plugins', "# PLUGINDIR=#{prefix}/plugins"
      s.gsub! '# TEMPLATEDIR=/opt/nikto/templates', "# TEMPLATEDIR=#{prefix}/templates"
      s.gsub! '# DOCDIR=/opt/nikto/docs', "# DOCDIR=#{prefix}/docs"
    end
    
    bin.install 'nikto.pl'                              # install main perl script
    bin.install_symlink 'nikto.pl' => 'nikto'           # symlink w/o extension
    prefix.install 'plugins', 'templates'               # install plugins, templates
    man1.install 'docs/nikto.1'                         # install man page
    (prefix + 'docs').install Dir['docs/*']             # miscellaneous
    etc.install 'nikto.conf'                            # install conf file
  end

  # run the test with `brew test nikto`
  def test
    system 'nikto'
    system 'nikto.pl'
  end
end
