class Mergepbx < Formula
  homepage "https://github.com/simonwagner/mergepbx"
  url "https://github.com/simonwagner/mergepbx/archive/v0.9.tar.gz"
  sha256 "d0d859a902357f8059fca0c5fb061a9072b82cb7cce4f38bd9eb2c3198fce003"

  resource "dummy_base" do
    url "https://raw.githubusercontent.com/simonwagner/mergepbx/a9bd9d8f4a732eff989ea03fbc0d78f6f6fb594f/test/fixtures/merge/dummy/dummy1/project.pbxproj.base"
    sha256 "d2cf3fdec1b37489e9bc219c82a7ee945c3dfc4672c8b4e89bc08ae0087d6477"
  end

  resource "dummy_mine" do
    url "https://raw.githubusercontent.com/simonwagner/mergepbx/a9bd9d8f4a732eff989ea03fbc0d78f6f6fb594f/test/fixtures/merge/dummy/dummy1/project.pbxproj.mine"
    sha256 "4c7147fbe518da6fa580879ff15a937be17ce1c0bc8edaaa15e1ef99a7b84282"
  end

  resource "dummy_theirs" do
    url "https://raw.githubusercontent.com/simonwagner/mergepbx/a9bd9d8f4a732eff989ea03fbc0d78f6f6fb594f/test/fixtures/merge/dummy/dummy1/project.pbxproj.theirs"
    sha256 "22bc5df1c602261e71f156768a851d3de9fa2561588822a17b4d3c9ee7b77901"
  end

  def install
    system "./build.py"
    bin.install "mergepbx"
  end

  test do
    system "mergepbx", "-h"

    resource("dummy_base").stage testpath
    resource("dummy_mine").stage testpath
    resource("dummy_theirs").stage testpath
    system "#{bin}/mergepbx", "project.pbxproj.base",
                              "project.pbxproj.mine",
                              "project.pbxproj.theirs"
  end
end
