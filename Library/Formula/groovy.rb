require 'formula'

class Groovy < Formula
  homepage 'http://groovy.codehaus.org/'
  url 'http://dl.bintray.com/groovy/maven/groovy-binary-2.2.2.zip'
  sha1 'af74f5e08c089ac6baf4bca99eeb9df209340368'

  option 'invokedynamic', "Install the InvokeDynamic version of Groovy (only works with Java 1.7+)"

  devel do
    url 'http://dl.bintray.com/groovy/maven/groovy-binary-2.3.0-rc-2.zip'
    sha1 '075c57f02663956662f52bc46c7964c536f42b1f'
    version '2.3.0-rc-2'
  end

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    if build.include? 'invokedynamic'
      Dir['indy/*.jar'].each do |src_path|
        dst_file = File.basename(src_path, '-indy.jar') + '.jar'
        dst_path = File.join('lib', dst_file)
        mv src_path, dst_path
      end
    end

    prefix.install_metafiles
    libexec.install %w(bin conf lib embeddable)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable GROOVY_HOME to
        #{opt_libexec}
    EOS
  end
end
