class ClearlooksPhenix < Formula
  desc "GTK+3 port of the Clearlooks Theme"
  homepage "https://github.com/jpfleury/clearlooks-phenix"
  url "https://github.com/jpfleury/clearlooks-phenix/archive/6.0.3.tar.gz"
  sha256 "663a40368107434b1333e42a630de74704f7b71a864e08d6b4ac1a5a68ccd874"
  head "https://github.com/jpfleury/clearlooks-phenix.git"

  depends_on "gtk+3"

  def install
    (share/"themes/Clearlooks-Phenix").install %w[gtk-2.0 gtk-3.0 index.theme]
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f",
           HOMEBREW_PREFIX/"share/themes/Clearlooks-Phenix"
  end

  test do
    assert File.exist?("#{share}/themes/Clearlooks-Phenix/index.theme")
  end
end
