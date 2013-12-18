require 'formula'

class Scalate < Formula
  homepage 'http://scalate.fusesource.org/'
  url 'http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/scalate/scalate-distro/1.5.3/scalate-distro-1.5.3-unix-bin.tar.gz'
  version '1.5.3'
  sha1 '17e3cd6252b36c9cf80566738299c7e19df957bf'

  def install
    # Recursively fix the permissions of extracted regular files
    # excluding the bin directory contents.
    %w{ archetypes docs lib samples license.txt readme.html }.each do |name|
      Pathname.new(name).find { |path| path.chmod(0644) if path.file? }
    end

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/scalate'
  end

  def caveats; <<-EOS.undent
    Scalate was installed to:
      #{libexec}
    EOS
  end
end
