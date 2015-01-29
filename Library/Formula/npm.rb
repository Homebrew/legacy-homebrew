class Npm < Formula
  homepage "https://www.npmjs.com/package/npm"
  url "https://registry.npmjs.org/npm/-/npm-2.3.0.tgz"
  sha1 "3588ec5c18fb5ac41e5721b0ea8ece3a85ab8b4b"

  option "without-completion", "npm bash completion will not be installed"

  depends_on :node

  # Patch node-gyp until github.com/TooTallNate/node-gyp/pull/564 is resolved
  patch :p3 do
    url "https://github.com/iojs/io.js/commit/82227f3.diff"
    sha1 "285ed82e27b088b9ad503187d810fd2d70defd51"
  end

  def install
    ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "completion"
        bash_completion.install \
        buildpath/"lib/utils/completion.sh" => "npm"
    end
  end

  def post_install
    # This is what makes everyone happy
    # make npm install everything to #{HOMEBREW_PREFIX}/lib/node_modules
    npmrc = lib/"node_modules/npm/npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats;
    s = ""
    s += <<-EOS.undent
      npm is prefixed to #{HOMEBREW_PREFIX} so global modules are installed to
        #{HOMEBREW_PREFIX}/lib/node_modules
      and then linked into
        #{HOMEBREW_PREFIX}/bin

    EOS

    s += <<-EOS.undent
      iojs currently requires a patched npm (i.e. not the npm installed by node).
      updating npm with npm currently will undo this patch.

    EOS

    s
  end

  test do
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
      assert_equal which("npm"), opt_bin/"npm"
  end
end

