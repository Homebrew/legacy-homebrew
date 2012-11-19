require 'formula'

class Mallet < Formula
  homepage 'http://mallet.cs.umass.edu/'
  url 'http://mallet.cs.umass.edu/dist/mallet-2.0.7.tar.gz'
  sha1 '45f6ad87ad7605d9f009be5f47b0bbf2ca47d89e'

  # Creates a wrapper to set the classpath before executing
  # the utility.
  def startup_script(name)
    <<-EOS.undent
      #!/bin/sh
      CLASSPATH=$CLASSPATH:#{libexec}/class:#{libexec}/lib/mallet-deps.jar "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    rm Dir['bin/*.{bat,dll,exe}'] # Remove all windows files
    prefix.install_metafiles
    libexec.install Dir['*']
    cd libexec+'bin' do
      Dir['*'].each do |file|
        fn = File.basename(file)
        (bin+fn).write startup_script(fn)
      end
    end
  end
end
