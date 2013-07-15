require 'formula'

class Rubinius < Formula
  homepage 'http://rubini.us/'
  url 'http://asset.rubini.us/rubinius-1.2.4-20110705.tar.gz'
  version '1.2.4'
  sha1 'c39c4fb1e62e0fb418453811636177e6ccf6a936'
  head 'https://github.com/rubinius/rubinius.git'

  env :std

  def install
    # Let Rubinius define its own flags; messing with these causes build breaks.
    ENV.remove_cc_etc

    # Unset RUBYLIB to configure Rubinius
    ENV.delete("RUBYLIB")

    # Set to stop Rubinius messing with our prefix.
    ENV["RELEASE"] = "1"

    ruby "./configure",
         "--skip-system", # download and use the prebuilt LLVM
         "--bindir", bin,
         "--prefix", prefix,
         "--includedir", "#{include}/rubinius",
         "--libdir", lib,
         "--mandir", man, # For completeness; no manpages exist yet.
         "--gemsdir", "#{lib}/rubinius/gems"

    ohai "config.rb", File.open('config.rb').to_a if ARGV.debug? or ARGV.verbose?

    ruby "-S", "rake", "install"

    # Remove conflicting command aliases
    bin.children.select(&:symlink?).each(&:unlink)
  end
end
