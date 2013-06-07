require 'formula'

class Neko < Formula
  homepage 'http://nekovm.org'
  url 'https://github.com/HaxeFoundation/neko.git', :revision => '6ab8f48a8dc62e4d917b599b3d8c8e10f764f839'
  version '2.0.0-6ab8f48'

  head 'https://github.com/HaxeFoundation/neko.git'

  depends_on 'bdw-gc'
  depends_on 'pcre'

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make", "os=osx", "LIB_PREFIX=#{HOMEBREW_PREFIX}", "INSTALL_FLAGS="

    lib.install 'bin/libneko.dylib'
    include.install Dir['vm/neko*.h']
    neko = lib/'neko'
    neko.install Dir['bin/*']

    # Symlink into bin so libneko.dylib resolves correctly for custom prefix
    bin.mkpath
    for file in ['neko', 'nekoc', 'nekoml', 'nekotools'] do
      (bin/file).make_relative_symlink(neko/file)
    end
  end

  def custom_prefix?
    HOMEBREW_PREFIX.to_s != '/usr/local'
  end

  test do
    ENV["NEKOPATH"] = "#{HOMEBREW_PREFIX}/lib/neko" if custom_prefix?
    system "#{bin}/neko", "#{HOMEBREW_PREFIX}/lib/neko/test.n"
  end

  def caveats
    s = ''
    if custom_prefix?
      s << <<-EOS.undent
        You must add the following line to your .bashrc or equivalent:
          export NEKOPATH="#{HOMEBREW_PREFIX}/lib/neko"
        EOS
    end
    s
  end
end
