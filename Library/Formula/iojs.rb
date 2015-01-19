class Iojs < Formula
  homepage "https://iojs.org/"
  url "https://iojs.org/dist/v1.0.3/iojs-v1.0.3.tar.gz"
  sha256 "c7fe7f71d9920f4cfd930f9022c7dddca7e11a0377fed1ee23e3241c2952db42"

  option "with-debug", "Build with debugger hooks"
  option "with-completion", "install bash completion for npm"

  depends_on :python => :build

  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-2.2.0.tgz"
    sha1 "e9a1c4971558019f3d14f7a33aa7a7492bc195ed"
  end

  def install
    args = %W[--prefix=#{libexec}/iojs --without-npm]
    args << "--debug" if build.with? "debug"

    system "./configure", *args
    system "make", "install"
    (bin+"iojs").write iojs_script

    resource("npm").stage buildpath/"npm_install"

    # make sure npm can find iojs
    ENV.prepend_path "PATH", libexec/"iojs/bin"
    # set log level temporarily for npm's `make install`
    ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"

    cd buildpath/"npm_install" do
      system "./configure", "--prefix=#{libexec}/npm"
      system "make", "install"
    end
    (bin+"npm-iojs").write npm_script

    if build.with? "completion"
      bash_completion.install \
        buildpath/"npm_install/lib/utils/completion.sh" => "npm"
    end
  end

  # This tells iojs where to find npm modules, and executes the hidden iojs.
  def iojs_script
    <<-EOS.undent
      #!/usr/bin/env bash
      export NODE_PATH=#{HOMEBREW_PREFIX}/share/iojs/
      exec #{libexec}/iojs/bin/iojs "$@"
    EOS
  end

  # This tells npm where to find iojs.
  def npm_script
    <<-EOS.undent
      #!/usr/bin/env bash
      export PATH=#{libexec}/iojs/bin:$PATH
      exec #{HOMEBREW_PREFIX}/share/iojs/bin/npm "$@"
    EOS
  end

  def post_install
    iojs_bindir = HOMEBREW_PREFIX/"share/iojs/bin"
    iojs_bindir.mkpath
    iojs_modules = HOMEBREW_PREFIX/"share/iojs/lib/node_modules"
    iojs_modules.mkpath
    npm_exec = iojs_modules/"npm/bin/npm-cli.js"
    # Kill npm but preserve all other modules across iojs updates/upgrades.
    rm_rf iojs_modules/"npm"

    cp_r libexec/"npm/lib/node_modules/npm", iojs_modules
    ln_sf npm_exec, iojs_bindir/"npm"

    # Let's do the manpage dance. It's just a jump to the left.
    # And then a step to the right, with your hand on rm_f.
    ["man1", "man3", "man5", "man7"].each do |man|
      mkdir_p HOMEBREW_PREFIX/"share/man/#{man}"
      rm_f Dir[HOMEBREW_PREFIX/"share/man/#{man}/{npm.,npm-,npmrc.}*"]
      ln_sf Dir[libexec/"npm/share/man/#{man}/{npm.,npm-,npmrc.}*"], HOMEBREW_PREFIX/"share/man/#{man}"
    end

    npm_root = iojs_modules/"npm"
    npmrc = npm_root/"npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}/share/iojs")
  end

  def caveats; <<-EOS.undent
    If you update npm itself, do NOT use the npm update command.
    The upstream-recommended way to update npm is:
      npm-iojs install -g npm@latest

    Executing `npm-iojs` in your terminal client will automatically,
    temporarily shunt iojs's Node symlink to the front of your $PATH.
    This allows npm to find the desired version of Node rather than
    any other version of Node available along the $PATH, and consequently
    you can directly install modules with `npm-iojs install -g grunt`.

    However, your modules installed via `npm` do not currently reside
    in your `$PATH` as there's a limited amount Homebrew can do to isolate
    those. If you wish to use those modules you should permanently
    prepend your `$PATH` like such:
      export PATH=#{HOMEBREW_PREFIX}/share/iojs/bin:#{libexec}/iojs/bin:$PATH

    Place that line in your bash_profile, zshrc, or similar.

    Be aware that without prepending the `$PATH` those modules will have
    extremely limited functionality.
    EOS
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/iojs #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus

    # make sure npm can find node
    ENV.prepend_path "PATH", libexec/"iojs/bin"
    assert_equal which("node"), libexec/"iojs/bin/node"
    assert (HOMEBREW_PREFIX/"bin/npm-iojs").exist?, "npm must exist"
    assert (HOMEBREW_PREFIX/"bin/npm-iojs").executable?, "npm must be executable"
    system "#{HOMEBREW_PREFIX}/bin/npm-iojs", "--verbose", "install", "npm@latest"
  end
end
