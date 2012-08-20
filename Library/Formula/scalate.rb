require 'formula'

class Scalate < Formula
  homepage 'http://scalate.fusesource.org/'
  url 'http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/scalate/scalate-distro/1.5.3/scalate-distro-1.5.3-unix-bin.tar.gz'
  version '1.5.3'
  md5 '5114f611836957f479c1f2060b20beb3'

  # This startup script for Scalate calls the real startup script installed
  # to Homebrew's cellar. This avoids issues with local vs. absolute symlinks.
  def startup_script; <<-EOS.undent
    #!/bin/bash
    "#{libexec}/bin/scalate" "$@"
    EOS
  end

  def install
    # Recursively fix the permissions of extracted regular files
    # excluding the bin directory contents.
    %w{ archetypes docs lib samples license.txt readme.html }.each do |name|
      Pathname.new(name).find { |path| path.chmod(0644) if path.file? }
    end

    prefix.install %w{ license.txt readme.html }
    libexec.install Dir['*']
    (bin+'scalate').write startup_script
  end

  def caveats; <<-EOS.undent
    Scalate was installed to:
      #{libexec}
    EOS
  end
end
