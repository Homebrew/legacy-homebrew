require 'formula'

class Cabal <Formula
  url 'http://www.haskell.org/cabal/release/cabal-install-0.8.2/cabal-install-0.8.2.tar.gz'
  homepage 'http://www.haskell.org/cabal/'
  md5 '4abd0933dff361ff69ee9288a211e4e1'

  aka 'cabal-install'
  depends_on :ghc

  def install
    unregister_broken_packages

    File.chmod 0755, 'bootstrap.sh'
    ENV['PREFIX'] = "#{prefix}"

    system "./bootstrap.sh"
    mv "#{bin}/cabal", "#{bin}/.cabal.bin"

    (var + 'cabal').install cabal_config
    bin.install cabal_wrapper

    ohai "Updating cabal package list..."
#    system "#{bin}/cabal", "update"
  end

  def unregister_broken_packages
    `ghc-pkg --simple-output check`.split.each {|p| unregister_package p }
  end

  def unregister_package pkg_name
    safe_system 'ghc-pkg', '--force', 'unregister', pkg_name
  end

  def cabal_wrapper
    File.open("cabal", "w") {|wrapper| wrapper.write <<-WRAPPER}
#!/bin/sh
export CABAL_CONFIG=#{var}/cabal/config
#{bin}/.cabal.bin \$*
    WRAPPER
    "cabal"
  end

  def cabal_config
    File.open("config", "w") {|config| config.write <<-CONFIG}
remote-repo: hackage.haskell.org:http://hackage.haskell.org/packages/archive
remote-repo-cache: #{var}/cabal/packages
user-install: False
documentation: True
build-summary: #{var}/cabal/logs/build.log
install-dirs global
  prefix: #{prefix}
    CONFIG
    "config"
  end
end
