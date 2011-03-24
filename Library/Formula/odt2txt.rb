require 'formula'

class Odt2txt < Formula
  # Retrieve the HEAD because no releases have been made since the commit that
  # includes Makefile rules for Mac OS X.
  head 'git://repo.or.cz/odt2txt.git'
  homepage 'http://stosberg.net/odt2txt/'

  def install
    inreplace "Makefile" do |s|
      # Don't add /opt on OS X
      s.gsub! "CFLAGS += -I/opt/local/include", ""
      s.gsub! "LDFLAGS += -L/opt/local/lib", ""
    end

    # Uses a custom makefile instead of autoconf; we set DESTDIR to the prefix value
    # Use the -B flag to force make the install target to circumvent bugs in the Makefile
    system "make", "-B", "DESTDIR=#{prefix}", "install"
  end
end
