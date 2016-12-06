require 'formula'
require 'pty'

class Stxxl < Formula
  homepage ''
  url 'http://sourceforge.net/projects/stxxl/files/stxxl/1.3.1/stxxl-1.3.1.tar.gz'
  md5 '8d0e8544c4c830cf9ae81c39b092438c'

  def install
    # Set up lib and include since stxxl's build doesn't do installs
    Dir.mkdir(lib)
    Dir.mkdir(include)

    ENV['CFLAGS'] = "-O3"
    # Build vanilla stxxl
    system "make",  "library_g++"

    # Manually copy library & header files
    FileUtils.cp("lib/libstxxl.a", lib)
    FileUtils.cp_r("include", prefix)
  end

  def test
    # Did library get built?
    File::exists? "#{prefix}/lib/libstxxl.a" and File::exists? "#{prefix}/include/stxxl.h"

    # Run ar to verify the library is valid
    ar_output = ''
    PTY.spawn("ar -t #{lib}/libstxxl.a") do |stdin, stdout, pid|
      begin
        stdin.each { |line| ar_output = ar_output + line }
      rescue Errno::EIO
        false
      end
    end

    # Verify ar output is what we expect
    head = /^__\.SYMDEF\s+iostats\.libstxxl\.o/
    (head =~ ar_output) == 0
 end
end
