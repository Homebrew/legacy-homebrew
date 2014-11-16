require 'formula'

class FlowTools < Formula
  homepage 'https://code.google.com/p/flow-tools/'
  url 'https://flow-tools.googlecode.com/files/flow-tools-0.68.5.1.tar.bz2'
  sha1 '4a843aada631650e3777a9b1eeb4ec46562cf0d0'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Generate test flow data with 1000 flows
    system "#{bin}/flow-gen > test.flow"
    # Test that the test flows work with some flow- programs
    system "#{bin}/flow-cat < test.flow"
    system "#{bin}/flow-header < test.flow"
    system "#{bin}/flow-print < test.flow"
    system "#{bin}/flow-stat < test.flow"
  end
end
