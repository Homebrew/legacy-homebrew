require 'formula'

class FlowTools < Formula
  homepage 'https://code.google.com/p/flow-tools/'
  url 'https://flow-tools.googlecode.com/files/flow-tools-0.68.5.1.tar.bz2'
  sha1 '4a843aada631650e3777a9b1eeb4ec46562cf0d0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    # Generate test flow data with 1000 flows
    system "flow-gen > test.flow"
    # Test that the test flows work with some flow- programs
    system "flow-cat < test.flow"
    system "flow-header < test.flow"
    system "flow-print < test.flow"
    system "flow-stat < test.flow"
  end
end
