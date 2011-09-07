require 'formula'

class UnsafeSubversionDownloadStrategy < SubversionDownloadStrategy
  def _fetch_command(svncommand, url, target)
    [
      svn, '--non-interactive', '--trust-server-cert',
      svncommand, '--force', url, target
    ]
  end
end

class Fortress < Formula
  url 'https://projectfortress.sun.com/svn/Community/tags/1.0',
      :using => UnsafeSubversionDownloadStrategy

  homepage 'http://projectfortress.sun.com/'
  version '1.0'

  head 'https://projectfortress.sun.com/svn/Community/trunk',
       :using => UnsafeSubversionDownloadStrategy

  def install
    # Yes it's crazy, but if FORTRESS_HOME is set while building
    # compilation will fail.
    ENV.delete 'FORTRESS_HOME' if ENV['FORTRESS_HOME']

    system './ant', 'clean', 'compile'
    rm_f Dir['bin/fortress.bat']

    libexec.install Dir['bin']

    project_fortress=libexec+'ProjectFortress'
    project_fortress.install Dir['ProjectFortress/build']
    third_party = project_fortress+'third_party'

    ['junit', 'xtc', 'jsr166y', 'plt'].each do |pkg|
      (third_party+pkg).install Dir["ProjectFortress/third_party/#{pkg}/#{pkg}.jar"]
    end

    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |f| ln_s f, bin }
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable FORTRESS_HOME to
        #{libexec}
    EOS
  end
end
