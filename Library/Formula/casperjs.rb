require 'formula'
class CasperJS < Formula
  homepage 'http://casperjs.org'
  head 'git://github.com/n1k0/casperjs.git'
  url 'https://github.com/n1k0/casperjs/tarball/0.6.8'
  md5 'cb72d1c5f33528e7020678e06d80352c'
  depends_on 'phantomjs'

  def script; <<-EOS.undent
    #!/bin/sh
    exec #{libexec}/casperjs "$@"
    EOS
  end

  def install
    inreplace 'bin/casperjs' do |s|
      s.gsub! /'bin', 'bootstrap.js'/, "'#{libexec}', 'bootstrap.js'"
    end
    inreplace 'bin/bootstrap.js' do |s|
      s.gsub! /'bin', 'usage.txt'/, "'libexec', 'usage.txt'"
    end
    prefix.install ['docs', 'modules', 'samples','package.json', 'tests', 'CHANGELOG.md', 'LICENSE.md']
    libexec.install ['bin/casperjs','bin/bootstrap.js', 'bin/usage.txt']
    (bin+'casperjs').write script
  end

end
