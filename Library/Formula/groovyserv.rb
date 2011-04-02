require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.6-src.zip'
  sha1 '5a812e9dfaa1aa0d6a769bd5c6ccbcefb970f135'
  head 'http://github.com/kobo/groovyserv.git', :using => :git

  depends_on 'groovy'
  depends_on 'maven'

  def install
    # Build
    system 'mvn package -Dmaven.test.skip=true'

    # Install executables in libexec to avoid conflicts
    Dir::chdir Dir['target/groovyserv-*/groovyserv-*/'].first do
      libexec.install %w{bin lib}
    end
    prefix.install %w{LICENSE.txt README.txt NOTICE.txt}

    # Remove windows files
    rm_f Dir["#{libexec}/bin/*.bat"]

    # Symlink binaries
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      ln_s f, bin + File.basename(f)
    end
  end
end
