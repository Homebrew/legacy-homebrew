require "formula"

class Execline < Formula
  homepage "http://skarnet.org/software/execline"
  url "http://skarnet.org/software/execline/execline-1.3.1.1.tar.gz"
  sha1 "2464e133aa75c21bff5a57edae4db6e873f0773e"

  depends_on "skalibs"

  def install
    ENV.deparallelize

    cd "execline-#{version}" do
      # configure
      cd "conf-compile" do
        write "conf-install-command",    "#{bin}"
        write "conf-install-include",    "#{include}"
        write "conf-install-library",    "#{lib}"
        write "conf-install-library.so", "#{lib}"
        write "conf-install-sysdeps",    "#{prefix}/sysdeps"
        write "conf-stripbins",          "strip -x"
        write "conf-striplibs",          "strip -x"

        skalibs = Formula["skalibs"].opt_prefix

        write "import",       "#{skalibs}/sysdeps"
        write "path-include", "#{skalibs}/include"
        write "path-library", "#{skalibs}/lib"

        rm_f  "flag-slashpackage"
        touch "flag-allstatic"
      end

      system "make", "install"
    end
  end

  test do
    output = `#{bin}/execlineb -c "echo hello"`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end

  private

  def write(path, str)
    File.open(path, "w") {|f| f.write(str) }
  end
end
