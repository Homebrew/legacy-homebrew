require 'formula'

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

  depends_on :python

  fails_with :llvm do
    build 2326
  end

  def install
    args = %W{--prefix=#{prefix}}

    args << "--debug" if build.include? 'enable-debug'

    system "./configure", *args
    system "make install"

  def caveats; <<-EOS.undent
      Homebrew has NOT installed npm. If you want npm (you do right?)
      then view the install instructions here:
      
      https://www.npmjs.org/doc/README.html#Fancy-Install-Unix
      
      It's easy.
    EOS
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = `#{bin}/node #{path}`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
