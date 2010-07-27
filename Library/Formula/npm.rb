require 'formula'

class Npm <Formula
  url 'http://github.com/isaacs/npm/tarball/v0.1.20'
  homepage 'http://github.com/isaacs/npm'
  md5 '9ad6a2892ea673c03c9df528c4ac25d6'
  head 'git://github.com/isaacs/npm.git'

  depends_on 'node'

  def executable
    <<-EOS
#!/bin/sh
exec "#{libexec}/cli.js" "$@"
    EOS
  end

  def install
    doc.install Dir["doc/*"]
    prefix.install ["LICENSE", "README.md"]

    # install all the required libs in libexec so `npm help` will work
    libexec.install Dir["*"]

    # add "npm-" prefix to man pages link them into the libexec man pages
    man1.mkpath
    Dir.chdir libexec+"man" do
      Dir["*"].each do |file|
        if file == "npm.1"
          ln_s "#{libexec}/man/#{file}", man1
        else
          ln_s "#{libexec}/man/#{file}", "#{man1}/npm-#{file}"
        end
      end
    end

    # install the wrapper executable
    (bin+"npm").write executable
  end
end
