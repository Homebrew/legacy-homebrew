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
  url 'http://nodejs.org/dist/v0.10.26/node-v0.10.26.tar.gz'
  sha1 '2340ec2dce1794f1ca1c685b56840dd515a271b2'

  devel do
    url 'http://nodejs.org/dist/v0.11.11/node-v0.11.11.tar.gz'
    sha1 '65b257ec6584bf339f06f58a8a02ba024e13f283'
  end

  head 'https://github.com/joyent/node.git'

  option 'enable-debug', 'Build with debugger hooks'
  option 'without-npm', 'npm will not be installed'
  option 'without-completion', 'npm bash completion will not be installed'

  depends_on NpmNotInstalled unless build.without? 'npm'
  depends_on :python

  fails_with :llvm do
    build 2326
  end

  def install
    args = %W{--prefix=#{prefix}}

    args << "--debug" if build.include? 'enable-debug'
    args << "--without-npm" if build.without? "npm"

    system "./configure", *args
    system "make install"

    if build.with? "npm"
      (lib/"node_modules/npm/npmrc").write("prefix = #{npm_prefix}\n")

      # Link npm manpages
      Pathname.glob("#{lib}/node_modules/npm/man/*").each do |man|
        dir = send(man.basename)
        man.children.each do |file|
          dir.install_symlink(file.relative_path_from(dir))
        end
      end

      if build.with? "completion"
        bash_completion.install_symlink \
          lib/"node_modules/npm/lib/utils/completion.sh" => "npm"
      end
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
    if build.without? "npm"; <<-end.undent
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

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/node #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
