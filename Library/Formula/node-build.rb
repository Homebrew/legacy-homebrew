class NodeBuild < Formula
  homepage "https://github.com/riywo/node-build"
  url "https://github.com/riywo/node-build/archive/v20140629.tar.gz"
  sha1 "9aed0fe610ddf49259d729ef7e07cdf1f29536fd"

  # node-build is a plugin for ndenv so we depend on that.
  depends_on "ndenv"

  def install
    prefix.install Dir["*"]

    # Install node-build as a plugin into ndenv's plugins path.
    plugins_path = HOMEBREW_PREFIX/"share/ndenv/plugins"
    plugin_link = HOMEBREW_PREFIX/"node-build"
    plugin_link.unlink if plugin_link.exist?
    plugins_path.install_symlink "#{opt_prefix}"
  end

  test do
    # Simple test to verify the node-build script executes.
    system "#{bin}/node-build", "--version"
  end
end
