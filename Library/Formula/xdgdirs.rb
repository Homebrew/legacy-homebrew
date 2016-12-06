class Xdgdirs < Formula
  desc "Display the XDG_* env vars related to the XDG Basedir Specification"
  homepage "http://www.gnuvola.org/software/xdgdirs/"
  url "http://www.gnuvola.org/software/xdgdirs/xdgdirs-2.2.tar.xz"
  sha256 "a7e3543eee10758a8ae6e493900c44ab946153887d56a46b96ae67f4d589e68c"

  depends_on "guile"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"

    # Clear out the environment of any existing XDG env vars to get consistent
    # behavior for the test
    new_env = ENV.reject { |name, _value| name.start_with? "XDG_" }

    xdg_str = nil
    error_str = nil

    # To support ruby 1.8.7 we use Open3.popen3 and threads to accomplish what
    # Open3.capture3 does
    stdin, stdout, stderr, wait_thr = Open3.popen3(new_env, "#{bin}/xdgdirs -l json homebrew")

    stdin.close

    output_thread = Thread.new { xdg_str = stdout.read }
    error_thread = Thread.new { error_str = stderr.read }

    output_thread.join
    error_thread.join

    # Ruby 1.8.7's popen3 apparently doesn't return a wait thread, so don't
    # bother checking its status if it doesn't exist.
    unless wait_thr.nil?
      assert_equal 0, wait_thr.value, "xdgdirs failed, stderr:\n#{error_str}"
    end

    xdg_values = Utils::JSON.load(xdg_str)
    assert_equal "#{Dir.home}/.config/homebrew", xdg_values["config-home"]
    assert_equal "#{Dir.home}/.local/share/homebrew", xdg_values["data-home"]
    assert_equal "#{Dir.home}/.cache/homebrew", xdg_values["cache-home"]
    assert_equal ["/usr/local/share/homebrew", "/usr/share/homebrew"], xdg_values["data-dirs"]
    assert_equal ["/etc/xdg/homebrew"], xdg_values["config-dirs"]
    assert_equal 0, xdg_values["runtime-dir"]

    # Try just changing a few values
    new_env["XDG_CONFIG_HOME"] = "/foo/bar"
    new_env["XDG_RUNTIME_DIR"] = "/baz/qux"

    stdin, stdout, stderr, wait_thr = Open3.popen3(new_env, "#{bin}/xdgdirs -l json homebrew")

    stdin.close

    output_thread = Thread.new { xdg_str = stdout.read }
    error_thread = Thread.new { error_str = stderr.read }

    output_thread.join
    error_thread.join

    # Ruby 1.8.7's popen3 apparently doesn't return a wait thread, so don't
    # bother checking its status if it doesn't exist.
    unless wait_thr.nil?
      assert_equal 0, wait_thr.value, "xdgdirs failed, stderr:\n#{error_str}"
    end

    xdg_values = Utils::JSON.load(xdg_str)
    assert_equal "/foo/bar/homebrew", xdg_values["config-home"]
    assert_equal "/baz/qux/homebrew", xdg_values["runtime-dir"]
  end
end
