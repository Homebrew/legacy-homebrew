require 'formula'

class CharmTools < Formula
  homepage 'https://launchpad.net/charm-tools'
  url 'https://launchpad.net/charm-tools/1.2/1.2.5/+download/charm-tools-1.2.5.tar.gz'
  sha1 'eb425dd554e471c6bae740d91cbc1b873c7e586d'

  depends_on :python
  depends_on 'libyaml'

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{libexec}"
    end

    # charm-tools installs its own copies of many, many common python
    # libraries; these shim scripts makes sure the privately-installed
    # tools can find them
    Dir[libexec/'bin/*charm*'].each do |tool|
      toolname = File.basename(tool)
      (bin/toolname).write <<-EOS.undent
      #!/bin/sh
      export PYTHONPATH=#{libexec}/lib/python2.7/site-packages
      exec #{tool}
      EOS
    end
  end

  def caveats
    python.standard_caveats if python
  end
end
