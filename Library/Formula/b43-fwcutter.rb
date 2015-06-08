class B43Fwcutter < Formula
  desc "Extract firmware from Braodcom 43xx driver files"
  homepage "http://wireless.kernel.org/en/users/Drivers/b43"
  url "http://bues.ch/b43/fwcutter/b43-fwcutter-019.tar.bz2"
  sha1 "64198fd2885b0eb0f8968ce3dc2037545b67f065"

  def install
    inreplace "Makefile" do |m|
      # Don't try to chown root:root on generated files
      m.gsub! /install -o 0 -g 0/, "install"
      m.gsub! /install -d -o 0 -g 0/, "install -d"
      # Fix manpage installation directory
      m.gsub! "$(PREFIX)/man", man
    end
    # b43-fwcutter has no ./configure
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/b43-fwcutter", "--version"
  end
end
