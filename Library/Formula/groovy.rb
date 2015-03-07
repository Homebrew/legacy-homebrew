require 'formula'

class Groovy < Formula
  homepage 'http://groovy.codehaus.org/'
  url 'http://dl.bintray.com/groovy/maven/groovy-binary-2.4.1.zip'
  sha1 '4f959f813582d4f2a7e2853a04d0772a35223282'

  option 'invokedynamic', "Install the InvokeDynamic version of Groovy (only works with Java 1.7+)"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    if build.include? 'invokedynamic'
      Dir.glob("indy/*.jar") do |src_path|
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
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end
end
