require 'formula'

class NpmNotInstalled < Requirement
  fatal true

  def modules_folder
    "#{HOMEBREW_PREFIX}/lib/node_modules"
  end

  def message; <<-EOS.undent
    Beginning with 0.8.0, this recipe now comes with npm.
    It appears you already have npm installed at #{modules_folder}/npm.
    To use the npm that comes with this recipe, first uninstall npm with
    `npm uninstall npm -g`, then run this command again.

    If you would like to keep your installation of npm instead of
    using the one provided with homebrew, install the formula with
    the `--without-npm` option.
    EOS
  end

  satisfy :build_env => false do
    begin
      path = Pathname.new("#{modules_folder}/npm/bin/npm")
      path.realpath.to_s.include?(HOMEBREW_CELLAR)
    rescue Errno::ENOENT
      true
    end
  end
end

# Note that x.even are stable releases, x.odd are devel releases
class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.10.22/node-v0.10.22.tar.gz'
  sha1 'd7c6a39dfa714eae1f8da7a00c9a07efd74a03b3'

  devel do
    url 'http://nodejs.org/dist/v0.11.7/node-v0.11.7.tar.gz'
    sha1 'a3b0d7fb818754ad55f06a02745d7ec53986de64'
  end

  head 'https://github.com/joyent/node.git'

  option 'enable-debug', 'Build with debugger hooks'
  option 'without-npm', 'npm will not be installed'

  depends_on NpmNotInstalled unless build.without? 'npm'
  depends_on :python => ["2.6", :build]

  fails_with :llvm do
    build 2326
  end

  # fixes gyp's detection of system paths on CLT-only systems
  def patches
    # Latest versions of NodeJS stable have changed gyp's xcode_emulation, so
    # it requires a different patch than devel currently. This will probably go away soon
    if build.stable?
      'https://gist.github.com/bbhoss/7439859/raw/9037240e90c62ce462383469874d4c269e3ead0d/xcode_emulation.patch'
    else
      'https://gist.github.com/bbhoss/7439831/raw/47a37bfaf3ca50e604f8ca346c9946d10519f563/xcode_emulation.patch'
    end
  end

  def install
    args = %W{--prefix=#{prefix}}

    args << "--debug" if build.include? 'enable-debug'
    args << "--without-npm" if build.include? 'without-npm'

    system "./configure", *args
    system "make install"

    unless build.include? 'without-npm'
      (lib/"node_modules/npm/npmrc").write("prefix = #{npm_prefix}\n")
    end
  end

  def npm_prefix
    d = "#{HOMEBREW_PREFIX}/share/npm"
    if File.directory? d
      d
    else
      HOMEBREW_PREFIX.to_s
    end
  end

  def caveats
    if build.include? 'without-npm' then <<-end.undent
      Homebrew has NOT installed npm. If you later install it, you should supplement
      your NODE_PATH with the npm module folder:
          #{npm_prefix}/lib/node_modules
      end
    elsif not ENV['PATH'].split(':').include? "#{npm_prefix}/bin"; <<-end.undent
      Probably you should amend your PATH to include npm-installed binaries:
          #{npm_prefix}/bin
      end
    end
  end
end
