require 'formula'

class Findbugs < Formula
  homepage 'http://findbugs.sourceforge.net/index.html'
  url 'https://downloads.sourceforge.net/project/findbugs/findbugs/2.0.2/findbugs-2.0.2.tar.gz'
  sha1 '3817d96e5143f513cb2945f14f50cdb6720d1f49'

  conflicts_with 'fb-client',
    :because => "findbugs and fb-client both install a `fb` binary"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir['*']

    bin.write_exec_script libexec/'bin/fb'
    bin.write_exec_script libexec/'bin/findbugs'
  end

  def caveats; <<-EOS.undent
    Some tools might refer findbugs by env variable.
    After installation, set $FINDBUGS_HOME in your profile:
      export FINDBUGS_HOME=#{libexec}
    EOS
  end

  test do
    system "#{bin}/fb"
  end
end
