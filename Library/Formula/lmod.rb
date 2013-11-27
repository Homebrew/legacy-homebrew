require 'formula'

class Lmod < Formula
  homepage 'http://www.tacc.utexas.edu/tacc-projects/lmod'
  url 'http://downloads.sourceforge.net/project/lmod/Lmod-5.1.5.tar.bz2'
  sha1 '337a7757e8101c0ddf35f9f7954ccba877419526'

  head 'https://github.com/TACC/Lmod.git'

  LMOD_OPTIONS = %w(ancient shortTime useDotFiles prependBlock duplicatePaths colorize settargs)
  LMOD_OPTIONS.each do |opt|
    option "with-#{opt}", "Build lmod and set #{opt}"
  end

  option 'with-spider-cache', "Build and deploy Lmod with a cache for installed modules."
  option 'with-update-system', "File to touch when the system is updated and new modules have been installed."

  depends_on 'lua'
  depends_on 'luarocks'

  def install
    opts = []
    opts += LMOD_OPTIONS.map do  |opt|
      "--with-#{opt}" if build.with?  opt
    end

    if build.with? 'spider-cache'
      opts << "--with-spiderCacheDir=#{prefix}/lmod/#{version}/cache"
    end

    if build.with? 'update-system'
      opts << "--with-updateSystemFn=#{prefix}/lmod/#{version}/system.txt"
    end

    system "luarocks install luaposix"
    system "luarocks install luafilesystem"
    system "./configure", "--prefix=#{prefix}", *opts
    system "make"
    system "make install"
  end

  def caveats
      <<-EOS.undent
        Make sure that you source #{prefix}/init/bash (if you use bash) to set your environment correctly.
        Use the other shell definitions if you use another shell.

        If you specified to use the spider cache, you will find the cache dir in
        #{prefix}/lmod/#{version}/cache.

        If you specified to use a system update file, you will find it in
        #{prefix}/lmod/#{version}/system.txt.
      EOS
  end

end
