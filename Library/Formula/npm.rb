require 'formula'

class Npm <Formula
  url 'http://github.com/isaacs/npm/tarball/v0.2.4'
  homepage 'http://github.com/isaacs/npm'
  md5 '0a43e65bef7ebecd6c2072d803e23512'
  head 'git://github.com/isaacs/npm.git'

  depends_on 'node'

  skip_clean 'share/npm/bin'

  def executable; <<-EOS
#!/bin/sh
exec "#{libexec}/cli.js" "$@"
EOS
  end

  def node_lib
    HOMEBREW_PREFIX+"lib/node"
  end

  def share_bin
    HOMEBREW_PREFIX+"share/npm/bin"
  end

  def install
    # Set a root & binroot that won't get wiped between updates
    share_bin.mkpath
    inreplace 'lib/utils/default-config.js' do |s|
      s.gsub! /, binroot.*$/, ", binroot : \"#{share_bin}\""
      s.gsub! /, root.*$/,    ", root : \"#{node_lib}\""
    end

    prefix.install ["LICENSE", "README.md"]
    doc.install Dir["doc/*"]

    # install all the required libs in libexec so `npm help` will work
    libexec.install Dir["*"]

    # add "npm-" prefix to man pages link them into the libexec man pages
    man1.mkpath
    Dir.chdir libexec + "man1" do
      Dir["*"].each do |file|
        if file == "npm.1"
          ln_s "#{Dir.pwd}/#{file}", man1
        else
          ln_s "#{Dir.pwd}/#{file}", "#{man1}/npm-#{file}"
        end
      end
    end

    # install the wrapper executable
    (bin+"npm").write executable
  end

  def caveats; <<-EOS.undent
    npm will install binaries to:
      #{share_bin}

    You may want to add this to your PATH.

    npm will install libraries to:
      #{node_lib}/.npm

    To manually remove libraries installed by npm, delete this (hidden!) folder.

    npm will also symlink libraries to:
      #{node_lib}

    You will want to add this to your NODE_PATH if you wish to
    require libraries without a path.
    EOS
  end
end
