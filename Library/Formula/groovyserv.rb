require 'formula'

class Groovyserv < Formula
  homepage 'http://kobo.github.com/groovyserv/'
  url 'https://github.com/downloads/kobo/groovyserv/groovyserv-0.9-src.zip'
  sha1 '54464608f90a381b44cf7959136e1b1f31a3919c'
  head 'http://github.com/kobo/groovyserv.git', :using => :git

  depends_on 'gradle' => :build
  depends_on 'groovy'

  def install
    system 'gradle clean executables'

    # Install executables in libexec to avoid conflicts
    Dir::chdir Dir['build/executables/'].first do
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
