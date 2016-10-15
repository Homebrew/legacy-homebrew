require "formula"

class S6 < Formula
  homepage "http://skarnet.org/software/s6"
  url "http://skarnet.org/software/s6/s6-1.1.3.1.tar.gz"
  sha1 "8e66bcf696f201b16687032e5e6624952df713e7"

  depends_on "skalibs"
  depends_on "execline"

  def install
    ENV.deparallelize

    cd "s6-#{version}" do
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
    t0 = Time.now
    output = `echo hello | #{bin}/s6-tai64n | #{bin}/s6-tai64nlocal`.strip
    t1 = Time.now

    assert_match /^\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d\.\d{9}  hello$/, output

    fields0, fields1 = [t0, t1].map do |t|
      [:year, :month, :day, :hour, :min].map {|f| t.send(f) }
    end

    if fields0 == fields1
      expected = "%04d-%02d-%02d %02d:%02d" % fields0
      assert_match /^#{expected}/, output
    end

    assert_equal 0, $?.exitstatus
  end

  private

  def write(path, str)
    File.open(path, "w") {|f| f.write(str) }
  end
end
