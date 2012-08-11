require 'formula'
require 'pathname'

class NpmNotInstalled < Requirement
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

  def satisfied?
    begin
      path = Pathname.new("#{modules_folder}/npm")
      not path.realpath.to_s.include?(HOMEBREW_CELLAR)
    rescue Exception => e
      true
    end
  end

  def fatal?
    true
  end
end

class Node < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.8.6/node-v0.8.6.tar.gz'
  sha1 '34c7ad2bb5450653748c65840155852d67742258'

  head 'https://github.com/joyent/node.git'

  # Leopard OpenSSL is not new enough, so use our keg-only one
  depends_on 'openssl' if MacOS.leopard?
  depends_on NpmNotInstalled.new unless ARGV.include? '--without-npm'

  fails_with :llvm do
    build 2326
  end

  # Stripping breaks dynamic loading
  skip_clean :all

  def options
    [
      ["--enable-debug", "Build with debugger hooks."],
      ["--without-npm", "Do not install alongside node."],
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]

    # Why skip npm install? Read https://github.com/mxcl/homebrew/pull/8784.
    if ARGV.include? '--without-npm'
      args << "--without-npm"
    end

    args << "--debug" if ARGV.include? '--enable-debug'

    system "./configure", *args
    system "make install"

    unless ARGV.include? '--without-npm'
      (lib + "node_modules/npm/npmrc").write npmrc
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
    if ARGV.include? '--without-npm'
      <<-EOS.undent
        Homebrew has NOT installed npm. We recommend the following method of
        installation:
          curl http://npmjs.org/install.sh | sh

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
