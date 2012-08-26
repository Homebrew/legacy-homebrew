require 'formula'

class Findbugs < Formula
  homepage 'http://findbugs.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/findbugs/files/findbugs/2.0.1/findbugs-2.0.1.tar.gz'
  sha1 '8358d28d90baecbf8590ef00b69c194ff1a8475c'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install 'README.txt'
    libexec.install Dir['*']

    (bin+'fb').write startup_script('fb')
    (bin+'findbugs').write startup_script('findbugs')
  end

  def caveats; <<-EOS.undent
    Some tools might refer findbugs by env variable.
    After installation, set $FINDBUGS_HOME in your profile:
      export FINDBUGS_HOME=#{libexec}
    EOS
  end

  def test
    system "#{bin}/fb"
  end
end
