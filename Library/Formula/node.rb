require 'formula'

class PythonVersion < Requirement
  env :userpaths

  satisfy { `python -c 'import sys;print(sys.version[:3])'`.strip.to_f >= 2.6 }

  def message;
    "Node's build system, gyp, requires Python 2.6 or newer."
  end
end

class NpmNotInstalled < Requirement
  fatal true

  def modules_folder
    "#{HOMEBREW_PREFIX}/lib/node_modules"
  end

  def message; <<-EOS.undent
    The homebrew node recipe now (beginning with 0.8.0) comes with npm.
    It appears you already have npm installed at #{modules_folder}/npm.
    To use the npm that comes with this recipe,
      first uninstall npm with `npm uninstall npm -g`.
      Then run this command again.

    If you would like to keep your installation of npm instead of
      using the one provided with homebrew,
      install the formula with the --without-npm option added.
    EOS
  end

  satisfy :build_env => false do
    begin
      path = Pathname.new("#{modules_folder}/npm")
      path.realpath.to_s.include?(HOMEBREW_CELLAR)
    rescue Exception => e
      true
    end
  end
end

class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.8.18/node-v0.8.18.tar.gz'
  sha1 'e3bc9b64f60f76a32b7d9b35bf86b5d1b8166717'

  devel do
    url 'http://nodejs.org/dist/v0.9.8/node-v0.9.8.tar.gz'
    sha1 'ce337f1f7baca56954412fbeaa25b4f9ea4c8528'
  end

  head 'https://github.com/joyent/node.git'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.version == :leopard
  depends_on NpmNotInstalled unless build.include? 'without-npm'
  depends_on PythonVersion

  option 'enable-debug', 'Build with debugger hooks'
  option 'without-npm', 'npm will not be installed'

  fails_with :llvm do
    build 2326
  end

  def install
    # Lie to `xcode-select` for now to work around a GYP bug that affects
    # CLT-only systems:
    #
    #   http://code.google.com/p/gyp/issues/detail?id=292
    #   joyent/node#3681
    ENV['DEVELOPER_DIR'] = MacOS.dev_tools_path unless MacOS::Xcode.installed?

    args = %W{--prefix=#{prefix}}
    args << "--debug" if build.include? 'enable-debug'
    args << "--without-npm" if build.include? 'without-npm'

    system "./configure", *args
    system "make install"

    unless build.include? 'without-npm'
      (lib/"node_modules/npm/npmrc").write(npmrc)
    end
  end

  def npm_prefix
    "#{HOMEBREW_PREFIX}/share/npm"
  end

  def npm_bin
    "#{npm_prefix}/bin"
  end

  def modules_folder
    "#{HOMEBREW_PREFIX}/lib/node_modules"
  end

  def npmrc
    <<-EOS.undent
      prefix = #{npm_prefix}
    EOS
  end

  def caveats
    if build.include? 'without-npm'
      <<-EOS.undent
        Homebrew has NOT installed npm. We recommend the following method of
        installation:
          curl https://npmjs.org/install.sh | sh

        After installing, add the following path to your NODE_PATH environment
        variable to have npm libraries picked up:
          #{modules_folder}
      EOS
    elsif not ENV['PATH'].split(':').include? npm_bin
      <<-EOS.undent
        Homebrew installed npm.
        We recommend prepending the following path to your PATH environment
        variable to have npm-installed binaries picked up:
          #{npm_bin}
      EOS
    end
  end
end
