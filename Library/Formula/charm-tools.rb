require 'formula'

class CharmTools < Formula
  homepage 'https://launchpad.net/charm-tools'
  url 'https://launchpad.net/charm-tools/1.0/1.0.1/+download/charmtools-1.0.1.tar.gz'
  sha1 '08c7a7c4f266c037d1405981adc080cd6c5be9e1'

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
