require 'formula'

class Dockutil < Formula
  homepage 'https://github.com/kcrawford/dockutil'
  url 'https://raw.github.com/kcrawford/dockutil/master/scripts/dockutil'
  sha1 'c54a9208b47795d0453f8f36d2056a866f8b9187'
  version '1.1.4'

  depends_on :python

  resource 'plistlib' do
    url 'https://pypi.python.org/packages/source/p/plist/plist-0.2.tar.gz'
    sha1 'eac8a0d71a20515f955101429101b3b9f445f809'
  end


  def install
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    python do
      resource('plistlib').stage { system python, *install_args }
    end

    bin.install 'dockutil'
  end

  test do
    assert_equal "1.1.4", `#{bin}/dockutil --version`.strip
  end
end
