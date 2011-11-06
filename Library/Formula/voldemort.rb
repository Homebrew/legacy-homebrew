require 'formula'

class Voldemort < Formula
  url 'https://github.com/downloads/voldemort/voldemort/voldemort-0.81.tar.gz'
  homepage 'http://project-voldemort.com/'
  md5 '38da11626c6704f2bda17d6461cd2928'

  def install
    system "ant"
    libexec.install %w(bin lib dist contrib)
    libexec.install "config" => "config-examples"
    (libexec+"config").mkpath

    # Write shim scripts for all utilities
    Dir["#{libexec}/bin/*.sh"].each do |p|
      script = File.basename(p)
      (bin+script).write <<-EOS
#!/bin/bash
#{p} $@
EOS
    end
  end

  def caveats; <<-EOS.undent
    You will need to set VOLDEMORT_HOME to:
      #{libexec}

    Config files should be placed in:
      #{libexec}/config
    or you can set VOL_CONF_DIR to a more reasonable path.
    EOS
  end
end
