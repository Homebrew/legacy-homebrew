class Npm < Formula
  homepage "https://www.npmjs.com/package/npm"
  url "https://registry.npmjs.org/npm/-/npm-2.3.0.tgz"
  sha1 "3588ec5c18fb5ac41e5721b0ea8ece3a85ab8b4b"

  option "without-completion", "npm bash completion will not be installed"

  depends_on "node" # || "iojs"  how?

  def install
    #TODO: Patch node-gyp for iojs compatability
    ENV["NPM_CONFIG_LOGLEVEL"] = "verbose"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "completion"
        bash_completion.install \
        buildpath/"lib/utils/completion.sh" => "npm"
    end
  end

  def post_install
    npmrc = lib/"node_modules/npm/npmrc"
    npmrc.atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
      assert (HOMEBREW_PREFIX/"bin/npm").exist?, "npm must exist"
      assert (HOMEBREW_PREFIX/"bin/npm").executable?, "npm must be executable"
  end

  def caveats; <<-EOS.undent
    npm is prefixed to #{HOMEBREW_PREFIX} so global modules are installed to
      #{HOMEBREW_PREFIX}/lib/node_modules
    and then linked into
      #{HOMEBREW_PREFIX}/bin
    EOS
  end
end
